import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/utils/formatters.dart';
import '../../../data/hive/boxes.dart';
import '../../../data/models/product.dart';
import '../../../data/models/sale_transaction.dart';
import '../../../l10n/app_localizations.dart';
import 'price_performance_card.dart';
import 'segment_tabs.dart';

class ProductSalesPerformanceSection extends StatelessWidget {
  const ProductSalesPerformanceSection({
    super.key,
    required this.product,
    required this.range,
    required this.onRangeChanged,
    required this.from,
    required this.to,
  });

  final Product product;
  final String range;
  final ValueChanged<String> onRangeChanged;
  final DateTime from;
  final DateTime to;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        SegmentTabs(
          value: range,
          onChanged: onRangeChanged,
          options: const ['1M', '6M', '1Y'],
        ),
        const SizedBox(height: 16),
        ValueListenableBuilder<Box<SaleTransaction>>(
          valueListenable: Hive.box<SaleTransaction>(
            HiveBoxes.transactions,
          ).listenable(),
          builder: (context, box, _) {
            final salesPerformance = _buildSalesPerformance(
              sales: box.values,
              product: product,
              from: from,
              to: to,
            );
            return PricePerformanceCard(
              title: l10n.productSalesPerformanceTitle,
              totalLabel: formatCurrency(salesPerformance.currentTotal),
              changePercent: salesPerformance.changePercent,
              values: salesPerformance.values,
              from: from,
              to: to,
              showLabels: false,
            );
          },
        ),
      ],
    );
  }

  _SalesPerformance _buildSalesPerformance({
    required Iterable<SaleTransaction> sales,
    required Product product,
    required DateTime from,
    required DateTime to,
  }) {
    final duration = to.difference(from);
    final totalMs = duration.inMilliseconds <= 0 ? 1 : duration.inMilliseconds;
    final durationDays = duration.inDays <= 0 ? 1 : duration.inDays;
    final bucketCount = durationDays <= 30 ? durationDays : 30;
    final values = List<double>.filled(bucketCount < 2 ? 2 : bucketCount, 0);

    var currentTotal = 0.0;
    for (final sale in sales) {
      final isCurrentPeriod =
          !sale.createdAt.isBefore(from) && sale.createdAt.isBefore(to);
      if (!isCurrentPeriod || !_isSameProduct(sale, product)) continue;

      currentTotal += sale.amount;
      final progressMs = sale.createdAt.difference(from).inMilliseconds;
      final progress = progressMs / totalMs;
      final index = (progress * values.length).floor().clamp(
        0,
        values.length - 1,
      );
      values[index] += sale.amount;
    }

    final previousFrom = from.subtract(duration);
    final previousTo = from;
    var previousTotal = 0.0;
    for (final sale in sales) {
      final isPreviousPeriod =
          !sale.createdAt.isBefore(previousFrom) &&
          sale.createdAt.isBefore(previousTo);
      if (!isPreviousPeriod || !_isSameProduct(sale, product)) continue;
      previousTotal += sale.amount;
    }

    final changePercent = previousTotal == 0
        ? (currentTotal == 0 ? 0.0 : 100.0)
        : ((currentTotal - previousTotal) / previousTotal) * 100;

    return _SalesPerformance(
      values: values,
      currentTotal: currentTotal,
      changePercent: changePercent,
    );
  }

  bool _isSameProduct(SaleTransaction sale, Product product) {
    if (sale.productId.isNotEmpty) return sale.productId == product.id;
    return sale.productName.trim().toLowerCase() ==
        product.name.trim().toLowerCase();
  }
}

class _SalesPerformance {
  const _SalesPerformance({
    required this.values,
    required this.currentTotal,
    this.changePercent,
  });

  final List<double> values;
  final double currentTotal;
  final double? changePercent;
}
