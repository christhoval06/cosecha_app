import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../../core/utils/formatters.dart';
import '../../data/hive/boxes.dart';
import '../../data/models/sale_transaction.dart';
import '../../data/repositories/performance_period_repository.dart';
import '../../l10n/app_localizations.dart';

class HomePerformanceDetailArgs {
  const HomePerformanceDetailArgs({required this.period});

  final PerformancePeriod period;
}

class HomePerformanceDetailScreen extends StatelessWidget {
  const HomePerformanceDetailScreen({super.key, required this.period});

  final PerformancePeriod period;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(_periodLabel(l10n, period))),
      body: SafeArea(
        child: ValueListenableBuilder<Box<SaleTransaction>>(
          valueListenable: Hive.box<SaleTransaction>(
            HiveBoxes.transactions,
          ).listenable(),
          builder: (context, box, _) {
            final detail = PerformancePeriodRepository().getDetail(period);
            final colorScheme = Theme.of(context).colorScheme;

            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  l10n.homePerformanceDetailPeriodSales,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  formatCurrency(detail.summary.current),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                _DeltaChip(deltaPercent: detail.summary.deltaPercent),
                const SizedBox(height: 8),
                Text(
                  _rangeLabel(context, detail.range),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.homePerformanceDetailProductsTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.homePerformanceDetailProductsSubtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 12),
                if (detail.products.isEmpty)
                  Text(
                    l10n.homePerformanceDetailNoSales,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  )
                else
                  ...detail.products.map((item) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item.productName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                _DeltaChip(deltaPercent: item.deltaPercent),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    formatCurrency(item.currentAmount),
                                    style: Theme.of(context).textTheme.bodyLarge
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Text(
                                  '${l10n.homePerformanceDetailQuantity}: ${item.currentQuantity}',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: colorScheme.onSurface.withValues(
                                          alpha: 0.72,
                                        ),
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${l10n.homePerformanceDetailPreviousPeriod}: ${formatCurrency(item.previousAmount)}',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: colorScheme.onSurface.withValues(
                                      alpha: 0.72,
                                    ),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
              ],
            );
          },
        ),
      ),
    );
  }

  String _rangeLabel(BuildContext context, PerformancePeriodRange range) {
    final locale = Localizations.localeOf(context).toString();
    final formatter = DateFormat('d MMM yyyy', locale);
    return '${formatter.format(range.from)} - ${formatter.format(range.to)}';
  }

  String _periodLabel(AppLocalizations l10n, PerformancePeriod period) {
    switch (period) {
      case PerformancePeriod.daily:
        return l10n.homeToday;
      case PerformancePeriod.weekly:
        return l10n.homeThisWeek;
      case PerformancePeriod.monthly:
        return l10n.homeThisMonth;
    }
  }
}

class _DeltaChip extends StatelessWidget {
  const _DeltaChip({required this.deltaPercent});

  final double deltaPercent;

  @override
  Widget build(BuildContext context) {
    final positive = deltaPercent >= 0;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: positive
            ? colorScheme.secondaryContainer
            : colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        formatPercentDelta(deltaPercent),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: positive
              ? colorScheme.onSecondaryContainer
              : colorScheme.onErrorContainer,
        ),
      ),
    );
  }
}
