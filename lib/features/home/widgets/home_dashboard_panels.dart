import 'package:cosecha_app/data/models/product.dart';
import 'package:cosecha_app/data/models/sale_transaction.dart';
import 'package:cosecha_app/data/repositories/sales_repository.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/constants/sales_channels.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/time_utils.dart';
import '../../../data/hive/boxes.dart';
import '../../../l10n/app_localizations.dart';
import 'dashboard_card.dart';
import 'performance_card.dart';
import 'quick_item.dart';
import 'recent_item.dart';

class HomePerformancePanel extends StatelessWidget {
  const HomePerformancePanel({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.homePerformanceOverview,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                letterSpacing: 1.2,
              ),
        ),
        const SizedBox(height: 12),
        ValueListenableBuilder<Box<SaleTransaction>>(
          valueListenable: Hive.box<SaleTransaction>(HiveBoxes.transactions).listenable(),
          builder: (context, box, _) {
            final repo = SalesRepository();
            final now = DateTime.now();
            final todayStart = DateTime(now.year, now.month, now.day);
            final weekStart = now.subtract(const Duration(days: 7));
            final monthStart = now.subtract(const Duration(days: 30));

            final today = repo.getPeriodSummary(todayStart, now);
            final week = repo.getPeriodSummary(weekStart, now);
            final month = repo.getPeriodSummary(monthStart, now);

            return Column(
              children: [
                PerformanceCard(
                  label: l10n.homeToday,
                  amount: formatCurrencyCompact(today.current),
                  delta: formatPercentDelta(today.deltaPercent),
                  deltaPositive: today.deltaPercent >= 0,
                  background: colorScheme.surface,
                ),
                const SizedBox(height: 12),
                PerformanceCard(
                  label: l10n.homeThisWeek,
                  amount: formatCurrencyCompact(week.current),
                  delta: formatPercentDelta(week.deltaPercent),
                  deltaPositive: week.deltaPercent >= 0,
                  background: colorScheme.surface,
                ),
                const SizedBox(height: 12),
                PerformanceCard(
                  label: l10n.homeThisMonth,
                  amount: formatCurrencyCompact(month.current),
                  delta: formatPercentDelta(month.deltaPercent),
                  deltaPositive: month.deltaPercent >= 0,
                  background: colorScheme.surface,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class HomeSalesGoalPanel extends StatelessWidget {
  const HomeSalesGoalPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    return ValueListenableBuilder<Box<SaleTransaction>>(
      valueListenable: Hive.box<SaleTransaction>(HiveBoxes.transactions).listenable(),
      builder: (context, box, _) {
        final now = DateTime.now();
        final monthStart = DateTime(now.year, now.month, 1);
        final prevMonthStart = DateTime(now.year, now.month - 1, 1);
        final currentMonth = _sumBetween(box.values, monthStart, now);
        final previousMonth = _sumBetween(box.values, prevMonthStart, monthStart);
        final estimatedGoal = previousMonth > 0
            ? previousMonth
            : (currentMonth > 0 ? currentMonth * 1.15 : 0.0);

        final progress =
            estimatedGoal <= 0 ? 0.0 : (currentMonth / estimatedGoal).clamp(0.0, 1.0);
        final overGoal = estimatedGoal > 0 && currentMonth > estimatedGoal;

        return DashboardCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.homeSalesGoalTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                l10n.homeSalesGoalSubtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
              ),
              const SizedBox(height: 12),
              if (estimatedGoal <= 0)
                Text(
                  l10n.homeNoSalesData,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                )
              else ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    minHeight: 10,
                    value: progress,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      overGoal ? colorScheme.secondary : colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formatCurrencyCompact(currentMonth),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    Text(
                      l10n.homeSalesGoalOf(formatCurrencyCompact(estimatedGoal)),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class HomeQuickActionsPanel extends StatelessWidget {
  const HomeQuickActionsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final actions = [
      _QuickActionDef(
        icon: Icons.point_of_sale,
        label: l10n.homeActionNewSale,
        route: AppRoutes.saleAdd,
      ),
      _QuickActionDef(
        icon: Icons.history,
        label: l10n.homeActionSalesHistory,
        route: AppRoutes.salesHistory,
      ),
      _QuickActionDef(
        icon: Icons.bar_chart,
        label: l10n.homeActionReports,
        route: AppRoutes.reports,
      ),
      _QuickActionDef(
        icon: Icons.backup_outlined,
        label: l10n.homeActionBackup,
        route: AppRoutes.dataBackup,
      ),
    ];

    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.homeQuickActionsTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            l10n.homeQuickActionsSubtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              for (final action in actions)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: FilledButton.tonalIcon(
                      onPressed: () =>
                          Navigator.of(context).pushNamed(action.route),
                      icon: Icon(action.icon, size: 18),
                      label: Text(
                        action.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class HomeChannelMixPanel extends StatelessWidget {
  const HomeChannelMixPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    return ValueListenableBuilder<Box<SaleTransaction>>(
      valueListenable: Hive.box<SaleTransaction>(HiveBoxes.transactions).listenable(),
      builder: (context, box, _) {
        final now = DateTime.now();
        final from = now.subtract(const Duration(days: 30));
        final sales = box.values.where((s) {
          return s.createdAt.isAfter(from) && s.createdAt.isBefore(now);
        }).toList();

        double retail = 0;
        double wholesale = 0;
        for (final sale in sales) {
          switch (SalesChannels.normalize(sale.channel)) {
            case SalesChannels.retail:
              retail += sale.amount;
            case SalesChannels.wholesale:
              wholesale += sale.amount;
          }
        }

        final total = retail + wholesale;
        final retailPct = total == 0 ? 0.0 : retail / total;
        final wholesalePct = total == 0 ? 0.0 : wholesale / total;

        return DashboardCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.homeChannelMixTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                l10n.homeChannelMixSubtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
              ),
              const SizedBox(height: 12),
              if (total <= 0)
                Text(
                  l10n.homeNoSalesData,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                )
              else ...[
                _ChannelMixRow(
                  label: l10n.salesChannelRetail,
                  share: retailPct,
                  totalLabel: formatCurrencyCompact(retail),
                  color: colorScheme.primary,
                ),
                const SizedBox(height: 10),
                _ChannelMixRow(
                  label: l10n.salesChannelWholesale,
                  share: wholesalePct,
                  totalLabel: formatCurrencyCompact(wholesale),
                  color: colorScheme.secondary,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _ChannelMixRow extends StatelessWidget {
  const _ChannelMixRow({
    required this.label,
    required this.share,
    required this.totalLabel,
    required this.color,
  });

  final String label;
  final double share;
  final String totalLabel;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
            Text(
              '${(share * 100).toStringAsFixed(0)}% · $totalLabel',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.75),
                  ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            minHeight: 8,
            value: share,
            backgroundColor: colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

class HomeProductsAtRiskPanel extends StatelessWidget {
  const HomeProductsAtRiskPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return ValueListenableBuilder<Box<Product>>(
      valueListenable: Hive.box<Product>(HiveBoxes.products).listenable(),
      builder: (context, productBox, _) {
        return ValueListenableBuilder<Box<SaleTransaction>>(
          valueListenable: Hive.box<SaleTransaction>(HiveBoxes.transactions).listenable(),
          builder: (context, salesBox, child) {
            final now = DateTime.now();
            final threshold = now.subtract(const Duration(days: 21));
            final sales = salesBox.values.toList();
            final products = productBox.values.toList();
            final risk = <_RiskProduct>[];

            for (final product in products) {
              DateTime? latestSale;
              for (final sale in sales) {
                final sameProduct = sale.productId.isNotEmpty
                    ? sale.productId == product.id
                    : sale.productName == product.name;
                if (!sameProduct) continue;
                if (latestSale == null || sale.createdAt.isAfter(latestSale)) {
                  latestSale = sale.createdAt;
                }
              }
              if (latestSale == null || latestSale.isBefore(threshold)) {
                final daysWithout = latestSale == null
                    ? null
                    : now.difference(latestSale).inDays;
                risk.add(
                  _RiskProduct(
                    name: product.name,
                    daysWithoutSales: daysWithout,
                  ),
                );
              }
            }

            risk.sort((a, b) {
              final aDays = a.daysWithoutSales ?? 99999;
              final bDays = b.daysWithoutSales ?? 99999;
              return bDays.compareTo(aDays);
            });

            return DashboardCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.homeProductsAtRiskTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.homeProductsAtRiskSubtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                  ),
                  const SizedBox(height: 12),
                  if (risk.isEmpty)
                    Text(
                      l10n.homeProductsAtRiskEmpty,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                    )
                  else
                    ...risk.take(3).map((item) {
                      final subtitle = item.daysWithoutSales == null
                          ? l10n.homeProductsAtRiskNoSales
                          : l10n.homeProductsAtRiskDaysNoSales(
                              item.daysWithoutSales!,
                            );
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.name,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            Text(
                              subtitle,
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: colorScheme.onSurface
                                        .withValues(alpha: 0.7),
                                  ),
                            ),
                          ],
                        ),
                      );
                    }),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pushNamed(AppRoutes.products),
                      child: Text(l10n.homeActionViewProducts),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class HomeAvgTicketTrendPanel extends StatelessWidget {
  const HomeAvgTicketTrendPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    return ValueListenableBuilder<Box<SaleTransaction>>(
      valueListenable: Hive.box<SaleTransaction>(HiveBoxes.transactions).listenable(),
      builder: (context, box, _) {
        final now = DateTime.now();
        final currentFrom = now.subtract(const Duration(days: 7));
        final previousFrom = now.subtract(const Duration(days: 14));

        final current = _statsBetween(box.values, currentFrom, now);
        final previous = _statsBetween(box.values, previousFrom, currentFrom);

        final deltaPercent = previous.avg == 0
            ? null
            : ((current.avg - previous.avg) / previous.avg) * 100;

        return DashboardCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.homeAvgTicketTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                l10n.homeAvgTicketSubtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      formatCurrencyCompact(current.avg),
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                  if (deltaPercent != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: deltaPercent >= 0
                            ? colorScheme.secondaryContainer
                            : colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        formatPercentDelta(deltaPercent),
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: deltaPercent >= 0
                                  ? colorScheme.onSecondaryContainer
                                  : colorScheme.onErrorContainer,
                            ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                l10n.homeAvgTicketTransactions(current.count),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class HomeWeeklyActivityPanel extends StatelessWidget {
  const HomeWeeklyActivityPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    return ValueListenableBuilder<Box<SaleTransaction>>(
      valueListenable: Hive.box<SaleTransaction>(HiveBoxes.transactions).listenable(),
      builder: (context, box, _) {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final start = today.subtract(const Duration(days: 6));
        final locale = Localizations.localeOf(context).toString();

        final points = <_DayActivity>[];
        for (var i = 0; i < 7; i++) {
          final dayStart = DateTime(start.year, start.month, start.day + i);
          final dayEnd = DateTime(dayStart.year, dayStart.month, dayStart.day + 1);
          final count = box.values.where((sale) {
            return !sale.createdAt.isBefore(dayStart) && sale.createdAt.isBefore(dayEnd);
          }).length;
          points.add(
            _DayActivity(
              day: dayStart,
              label: DateFormat.E(locale).format(dayStart).substring(0, 1).toUpperCase(),
              count: count,
            ),
          );
        }

        final maxCount = points.fold<int>(0, (max, item) {
          return item.count > max ? item.count : max;
        });

        return DashboardCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.homeWeeklyActivityTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                l10n.homeWeeklyActivitySubtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
              ),
              const SizedBox(height: 14),
              if (maxCount == 0)
                Text(
                  l10n.homeNoSalesData,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                )
              else
                SizedBox(
                  height: 120,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      for (final point in points)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 280),
                                      height: 14 + ((point.count / maxCount) * 64),
                                      decoration: BoxDecoration(
                                        color: point.day == today
                                            ? colorScheme.primary
                                            : colorScheme.primary.withValues(alpha: 0.45),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  point.label,
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                        color: colorScheme.onSurface
                                            .withValues(alpha: 0.7),
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class HomeWeeklyInsightsPanel extends StatelessWidget {
  const HomeWeeklyInsightsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return ValueListenableBuilder<Box<SaleTransaction>>(
      valueListenable: Hive.box<SaleTransaction>(HiveBoxes.transactions).listenable(),
      builder: (context, box, _) {
        final now = DateTime.now();
        final currentFrom = now.subtract(const Duration(days: 7));
        final previousFrom = now.subtract(const Duration(days: 14));
        final current = _salesBetween(box.values, currentFrom, now);
        final previous = _salesBetween(box.values, previousFrom, currentFrom);

        final insights = <String>[];
        final currentTotal = current.fold<double>(0.0, (sum, item) => sum + item.amount);
        final previousTotal = previous.fold<double>(0.0, (sum, item) => sum + item.amount);

        if (previousTotal > 0 && currentTotal > 0) {
          final delta = ((currentTotal - previousTotal) / previousTotal) * 100;
          if (delta.abs() >= 5) {
            final direction = delta >= 0 ? l10n.homeInsightDirectionUp : l10n.homeInsightDirectionDown;
            insights.add(
              l10n.homeInsightRevenueDelta(
                direction,
                formatPercentDelta(delta),
                formatCurrencyCompact(currentTotal - previousTotal),
              ),
            );
          }
        }

        final currentMix = _channelShare(current);
        final previousMix = _channelShare(previous);
        final retailShift = currentMix.retail - previousMix.retail;
        final wholesaleShift = currentMix.wholesale - previousMix.wholesale;

        if (retailShift.abs() >= 0.1 || wholesaleShift.abs() >= 0.1) {
          final useRetail = retailShift.abs() >= wholesaleShift.abs();
          final channelLabel = useRetail ? l10n.salesChannelRetail : l10n.salesChannelWholesale;
          final shift = useRetail ? retailShift : wholesaleShift;
          insights.add(
            l10n.homeInsightChannelShift(
              channelLabel,
              '${(shift.abs() * 100).toStringAsFixed(0)}%',
            ),
          );
        }

        final topByAmount = <String, double>{};
        for (final sale in current) {
          final key = sale.productId.isNotEmpty ? sale.productId : sale.productName;
          topByAmount[key] = (topByAmount[key] ?? 0) + sale.amount;
        }
        if (topByAmount.isNotEmpty) {
          final topKey = topByAmount.entries.reduce((a, b) {
            return a.value >= b.value ? a : b;
          }).key;
          final topSale = current.firstWhere(
            (item) => (item.productId.isNotEmpty ? item.productId : item.productName) == topKey,
          );
          insights.add(l10n.homeInsightTopProduct(topSale.productName));
        }

        if (insights.isEmpty) {
          insights.add(l10n.homeInsightNoSignificantChange);
        }

        return DashboardCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.homeWeeklyInsightsTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                l10n.homeWeeklyInsightsSubtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
              ),
              const SizedBox(height: 12),
              for (final text in insights.take(3))
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.insights_outlined,
                        size: 16,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          text,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class HomeQuickSalePanel extends StatelessWidget {
  const HomeQuickSalePanel({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.homeQuickSale,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                letterSpacing: 1.2,
              ),
        ),
        const SizedBox(height: 12),
        ValueListenableBuilder<Box<Product>>(
          valueListenable: Hive.box<Product>(HiveBoxes.products).listenable(),
          builder: (context, productBox, _) {
            if (productBox.values.isEmpty) {
              return SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pushNamed(AppRoutes.products),
                  child: Text(l10n.homeQuickAddProducts),
                ),
              );
            }

            return ValueListenableBuilder<Box<SaleTransaction>>(
              valueListenable: Hive.box<SaleTransaction>(HiveBoxes.transactions).listenable(),
              builder: (context, salesBox, _) {
                final topProducts = SalesRepository().getTopProducts(limit: 3);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (final product in topProducts)
                      QuickItem(
                        label: product.name,
                        imagePath: product.imageUrl,
                        onTap: () => Navigator.of(
                          context,
                        ).pushNamed(AppRoutes.saleAdd, arguments: product),
                      ),
                  ],
                );
              },
            );
          },
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.saleAdd),
            icon: const Icon(Icons.add),
            label: Text(l10n.homeAddSale),
          ),
        ),
      ],
    );
  }
}

class HomeRecentSalesPanel extends StatelessWidget {
  const HomeRecentSalesPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.homeRecentSales,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pushNamed(AppRoutes.salesHistory),
              child: Text(l10n.homeSeeHistory),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ValueListenableBuilder<Box<SaleTransaction>>(
          valueListenable: Hive.box<SaleTransaction>(HiveBoxes.transactions).listenable(),
          builder: (context, box, _) {
            final items = box.values.toList()
              ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
            final recent = items.take(3).toList();
            if (recent.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  l10n.homeRecentEmpty,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                ),
              );
            }

            return Column(
              children: [
                for (final sale in recent) ...[
                  RecentItem(
                    title: sale.productName,
                    subtitle: relativeTime(l10n, sale.createdAt),
                    amount: sale.formatAmount(),
                  ),
                  if (sale != recent.last) const SizedBox(height: 8),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}

class _DayActivity {
  const _DayActivity({
    required this.day,
    required this.label,
    required this.count,
  });

  final DateTime day;
  final String label;
  final int count;
}

class _QuickActionDef {
  const _QuickActionDef({
    required this.icon,
    required this.label,
    required this.route,
  });

  final IconData icon;
  final String label;
  final String route;
}

class _RiskProduct {
  const _RiskProduct({
    required this.name,
    required this.daysWithoutSales,
  });

  final String name;
  final int? daysWithoutSales;
}

class _RangeStats {
  const _RangeStats({
    required this.total,
    required this.count,
  });

  final double total;
  final int count;

  double get avg => count == 0 ? 0.0 : total / count;
}

double _sumBetween(Iterable<SaleTransaction> sales, DateTime from, DateTime to) {
  return sales.where((sale) {
    return !sale.createdAt.isBefore(from) && sale.createdAt.isBefore(to);
  }).fold(0.0, (sum, sale) => sum + sale.amount);
}

List<SaleTransaction> _salesBetween(
  Iterable<SaleTransaction> sales,
  DateTime from,
  DateTime to,
) {
  return sales.where((sale) {
    return !sale.createdAt.isBefore(from) && sale.createdAt.isBefore(to);
  }).toList();
}

_RangeStats _statsBetween(Iterable<SaleTransaction> sales, DateTime from, DateTime to) {
  var total = 0.0;
  var count = 0;
  for (final sale in sales) {
    if (sale.createdAt.isBefore(from) || !sale.createdAt.isBefore(to)) continue;
    total += sale.amount;
    count++;
  }
  return _RangeStats(total: total, count: count);
}

_ChannelShare _channelShare(Iterable<SaleTransaction> sales) {
  var retail = 0.0;
  var wholesale = 0.0;
  var total = 0.0;
  for (final sale in sales) {
    final amount = sale.amount;
    total += amount;
    switch (SalesChannels.normalize(sale.channel)) {
      case SalesChannels.retail:
        retail += amount;
        break;
      case SalesChannels.wholesale:
        wholesale += amount;
        break;
      default:
        break;
    }
  }
  if (total <= 0) return const _ChannelShare(retail: 0, wholesale: 0);
  return _ChannelShare(retail: retail / total, wholesale: wholesale / total);
}

class _ChannelShare {
  const _ChannelShare({
    required this.retail,
    required this.wholesale,
  });

  final double retail;
  final double wholesale;
}
