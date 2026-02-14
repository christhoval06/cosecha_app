import 'package:hive/hive.dart';

import '../hive/boxes.dart';
import '../models/sale_transaction.dart';
import 'sales_repository.dart';

enum PerformancePeriod { daily, weekly, monthly }

class PerformancePeriodDetail {
  PerformancePeriodDetail({
    required this.summary,
    required this.range,
    required this.products,
  });

  final SalesPeriodSummary summary;
  final PerformancePeriodRange range;
  final List<ProductPerformance> products;
}

class ProductPerformance {
  ProductPerformance({
    required this.productId,
    required this.productName,
    required this.currentAmount,
    required this.previousAmount,
    required this.currentQuantity,
    required this.deltaPercent,
  });

  final String productId;
  final String productName;
  final double currentAmount;
  final double previousAmount;
  final int currentQuantity;
  final double deltaPercent;
}

class PerformancePeriodRange {
  PerformancePeriodRange({
    required this.from,
    required this.to,
    required this.previousFrom,
    required this.previousTo,
  });

  final DateTime from;
  final DateTime to;
  final DateTime previousFrom;
  final DateTime previousTo;
}

class PerformancePeriodRepository {
  Box<SaleTransaction> get _box =>
      Hive.box<SaleTransaction>(HiveBoxes.transactions);

  PerformancePeriodDetail getDetail(PerformancePeriod period, {DateTime? now}) {
    final end = now ?? DateTime.now();
    final range = _resolveRange(period, end);
    final summary = SalesRepository().getPeriodSummary(range.from, range.to);

    final currentSales = _salesBetween(range.from, range.to);
    final previousSales = _salesBetween(range.previousFrom, range.previousTo);

    final previousByKey = _aggregate(previousSales);
    final currentByKey = _aggregate(currentSales);

    final products = currentByKey.entries.map((entry) {
      final current = entry.value;
      final previous =
          previousByKey[entry.key] ??
          _AggregatedProduct.empty(current.productName);
      final deltaPercent = _computeDelta(
        currentAmount: current.amount,
        previousAmount: previous.amount,
      );

      return ProductPerformance(
        productId: current.productId,
        productName: current.productName,
        currentAmount: current.amount,
        previousAmount: previous.amount,
        currentQuantity: current.quantity,
        deltaPercent: deltaPercent,
      );
    }).toList()..sort((a, b) => b.currentAmount.compareTo(a.currentAmount));

    return PerformancePeriodDetail(
      summary: summary,
      range: range,
      products: products,
    );
  }

  PerformancePeriodRange _resolveRange(PerformancePeriod period, DateTime now) {
    switch (period) {
      case PerformancePeriod.daily:
        final from = DateTime(now.year, now.month, now.day);
        final duration = now.difference(from);
        return PerformancePeriodRange(
          from: from,
          to: now,
          previousFrom: from.subtract(duration),
          previousTo: from,
        );
      case PerformancePeriod.weekly:
        final from = now.subtract(const Duration(days: 7));
        return _rollingRange(from, now);
      case PerformancePeriod.monthly:
        final from = now.subtract(const Duration(days: 30));
        return _rollingRange(from, now);
    }
  }

  PerformancePeriodRange _rollingRange(DateTime from, DateTime to) {
    final duration = to.difference(from);
    return PerformancePeriodRange(
      from: from,
      to: to,
      previousFrom: from.subtract(duration),
      previousTo: from,
    );
  }

  List<SaleTransaction> _salesBetween(DateTime from, DateTime to) {
    return _box.values
        .where(
          (sale) => sale.createdAt.isAfter(from) && sale.createdAt.isBefore(to),
        )
        .toList();
  }

  Map<String, _AggregatedProduct> _aggregate(List<SaleTransaction> sales) {
    final result = <String, _AggregatedProduct>{};
    for (final sale in sales) {
      final key = _productKey(sale);
      final current = result[key];
      if (current == null) {
        result[key] = _AggregatedProduct(
          productId: sale.productId,
          productName: sale.productName,
          amount: sale.amount,
          quantity: sale.quantity,
        );
      } else {
        result[key] = _AggregatedProduct(
          productId: current.productId,
          productName: current.productName,
          amount: current.amount + sale.amount,
          quantity: current.quantity + sale.quantity,
        );
      }
    }
    return result;
  }

  String _productKey(SaleTransaction sale) {
    if (sale.productId.trim().isNotEmpty) {
      return 'id:${sale.productId.trim()}';
    }
    return 'name:${sale.productName.trim().toLowerCase()}';
  }

  double _computeDelta({
    required double currentAmount,
    required double previousAmount,
  }) {
    if (previousAmount == 0) return currentAmount == 0 ? 0 : 100;
    return ((currentAmount - previousAmount) / previousAmount) * 100;
  }
}

class _AggregatedProduct {
  _AggregatedProduct({
    required this.productId,
    required this.productName,
    required this.amount,
    required this.quantity,
  });

  factory _AggregatedProduct.empty(String productName) {
    return _AggregatedProduct(
      productId: '',
      productName: productName,
      amount: 0,
      quantity: 0,
    );
  }

  final String productId;
  final String productName;
  final double amount;
  final int quantity;
}
