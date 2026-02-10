import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/services/excel_export_service.dart';
import '../../../core/widgets/excel_export_config_sheet.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/repositories/reports_repository.dart';
import '../../../l10n/app_localizations.dart';
import '../dashboard/report_filters.dart';
import 'heatmap_card.dart';
import 'monthly_sales_bar_chart.dart';
import 'sparkline_card.dart';
import 'summary_row.dart';
import 'top_product_tile.dart';

class ReportsExportToolsPanel extends StatelessWidget {
  const ReportsExportToolsPanel(this.filters, {super.key});

  final ReportFilters filters;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.reportsExportToolsTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            l10n.reportsExportToolsSubtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final current = await ExcelExportService.loadConfig();
                    if (!context.mounted) return;
                    final updated = await showExcelExportConfigSheet(
                      context: context,
                      current: current,
                    );
                    if (updated == null) return;
                    await ExcelExportService.saveConfig(updated);
                  },
                  icon: const Icon(Icons.tune),
                  label: Text(l10n.reportsExportConfigure),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () async {
                    try {
                      final config = await ExcelExportService.loadConfig();
                      final path = await ExcelExportService.exportToExcel(
                        config: config,
                      );
                      if (!context.mounted) return;
                      await Share.shareXFiles(
                        [XFile(path)],
                        sharePositionOrigin: _shareOrigin(context),
                      );
                    } catch (error) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${l10n.errorTitle}: $error')),
                      );
                    }
                  },
                  icon: const Icon(Icons.table_view),
                  label: Text(l10n.reportsExportRun),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ReportsSummaryPanel extends StatelessWidget {
  const ReportsSummaryPanel(this.filters, {super.key});

  final ReportFilters filters;

  @override
  Widget build(BuildContext context) {
    final repo = ReportsRepository();
    final total = repo.totalAmount(
      filters.from,
      filters.to,
      where: filters.matchesSale,
    );
    final count = repo.totalCount(
      filters.from,
      filters.to,
      where: filters.matchesSale,
    );
    final avg = count == 0 ? 0.0 : total / count;
    return SummaryRow(total: total, count: count, avg: avg);
  }
}

class ReportsPeriodComparisonPanel extends StatelessWidget {
  const ReportsPeriodComparisonPanel(this.filters, {super.key});

  final ReportFilters filters;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final repo = ReportsRepository();

    final currentTotal = repo.totalAmount(
      filters.from,
      filters.to,
      where: filters.matchesSale,
    );
    final currentCount = repo.totalCount(
      filters.from,
      filters.to,
      where: filters.matchesSale,
    );
    final currentAvg = currentCount == 0 ? 0.0 : currentTotal / currentCount;

    final duration = filters.to.difference(filters.from);
    final previousFrom = filters.from.subtract(duration);
    final previousTo = filters.from;
    final prevTotal = repo.totalAmount(
      previousFrom,
      previousTo,
      where: filters.matchesSale,
    );
    final prevCount = repo.totalCount(
      previousFrom,
      previousTo,
      where: filters.matchesSale,
    );
    final prevAvg = prevCount == 0 ? 0.0 : prevTotal / prevCount;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.reportsPeriodComparisonTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            l10n.reportsPeriodComparisonSubtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
          ),
          const SizedBox(height: 12),
          _MetricComparisonTile(
            label: l10n.reportsTotalSales,
            value: formatCurrencyCompact(currentTotal),
            delta: _deltaPercent(currentTotal, prevTotal),
          ),
          const SizedBox(height: 10),
          _MetricComparisonTile(
            label: l10n.reportsTransactions,
            value: currentCount.toString(),
            delta: _deltaPercent(currentCount.toDouble(), prevCount.toDouble()),
          ),
          const SizedBox(height: 10),
          _MetricComparisonTile(
            label: l10n.reportsAvgTicket,
            value: formatCurrencyCompact(currentAvg),
            delta: _deltaPercent(currentAvg, prevAvg),
          ),
        ],
      ),
    );
  }
}

class ReportsTotalSalesTrendPanel extends StatelessWidget {
  const ReportsTotalSalesTrendPanel(this.filters, {super.key});

  final ReportFilters filters;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final repo = ReportsRepository();
    final total = repo.totalAmount(
      filters.from,
      filters.to,
      where: filters.matchesSale,
    );
    final series = repo.dailySeries(
      filters.from,
      filters.to,
      where: filters.matchesSale,
    );
    final rangeDuration = filters.to.difference(filters.from);
    final prevFrom = filters.from.subtract(rangeDuration);
    final prevTo = filters.from;
    final prevTotal = repo.totalAmount(
      prevFrom,
      prevTo,
      where: filters.matchesSale,
    );
    final changePercent =
        prevTotal == 0 ? null : ((total - prevTotal) / prevTotal) * 100;

    return SparklineCard(
      title: l10n.reportsTotalSales,
      totalLabel: formatCurrency(total),
      changePercent: changePercent,
      values: series,
      from: filters.from,
      to: filters.to,
    );
  }
}

class ReportsMonthlySalesPanel extends StatelessWidget {
  const ReportsMonthlySalesPanel(this.filters, {super.key});

  final ReportFilters filters;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final repo = ReportsRepository();
    final monthlyTotals = repo.monthlyTotalsLastMonths(
      months: 6,
      reference: filters.to,
      where: filters.matchesSale,
    );
    return MonthlySalesBarChart(
      title: l10n.reportsMonthlySalesLast6,
      items: monthlyTotals,
    );
  }
}

class ReportsChannelMixPanel extends StatelessWidget {
  const ReportsChannelMixPanel(this.filters, {super.key});

  final ReportFilters filters;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final repo = ReportsRepository();
    final breakdown = repo.channelBreakdown(
      filters.from,
      filters.to,
      where: filters.matchesSale,
    );
    final total = breakdown.total;

    final retailShare = total == 0 ? 0.0 : breakdown.retail / total;
    final wholesaleShare = total == 0 ? 0.0 : breakdown.wholesale / total;
    final otherShare = total == 0 ? 0.0 : breakdown.other / total;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.reportsChannelMixTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            l10n.reportsChannelMixSubtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
          ),
          const SizedBox(height: 12),
          if (total <= 0)
            Text(
              l10n.reportsTopEmpty,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
            )
          else ...[
            _ChannelMixBar(
              label: l10n.salesChannelRetail,
              share: retailShare,
              amount: breakdown.retail,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 10),
            _ChannelMixBar(
              label: l10n.salesChannelWholesale,
              share: wholesaleShare,
              amount: breakdown.wholesale,
              color: colorScheme.secondary,
            ),
            if (breakdown.other > 0) ...[
              const SizedBox(height: 10),
              _ChannelMixBar(
                label: l10n.reportsChannelOther,
                share: otherShare,
                amount: breakdown.other,
                color: colorScheme.tertiary,
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class ReportsHeatmapPanel extends StatelessWidget {
  const ReportsHeatmapPanel(this.filters, {super.key});

  final ReportFilters filters;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final repo = ReportsRepository();
    final heatmap = repo.dailyTotals(
      filters.from,
      filters.to,
      where: filters.matchesSale,
    );
    return HeatmapCard(
      title: l10n.reportsDailyHeatmap,
      totals: heatmap,
      to: filters.to,
    );
  }
}

class ReportsTopProductsPanel extends StatelessWidget {
  const ReportsTopProductsPanel(this.filters, {super.key});

  final ReportFilters filters;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final repo = ReportsRepository();
    final top = repo.topProducts(
      filters.from,
      filters.to,
      limit: 5,
      where: filters.matchesSale,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.reportsTopProducts,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        if (top.isEmpty)
          Text(
            l10n.reportsTopEmpty,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
          )
        else
          ...top.map((item) => TopProductTile(item: item)),
      ],
    );
  }
}

class ReportsBottomProductsPanel extends StatelessWidget {
  const ReportsBottomProductsPanel(this.filters, {super.key});

  final ReportFilters filters;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final repo = ReportsRepository();
    final bottom = repo.bottomProducts(
      filters.from,
      filters.to,
      limit: 5,
      where: filters.matchesSale,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.reportsBottomProducts,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        if (bottom.isEmpty)
          Text(
            l10n.reportsTopEmpty,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
          )
        else
          ...bottom.map((item) => TopProductTile(item: item)),
      ],
    );
  }
}

class _MetricComparisonTile extends StatelessWidget {
  const _MetricComparisonTile({
    required this.label,
    required this.value,
    required this.delta,
  });

  final String label;
  final String value;
  final double? delta;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final positive = (delta ?? 0) >= 0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
          ),
          if (delta != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: positive
                    ? colorScheme.secondaryContainer
                    : colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                formatPercentDelta(delta!),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: positive
                          ? colorScheme.onSecondaryContainer
                          : colorScheme.onErrorContainer,
                    ),
              ),
            )
          else
            Text(
              '--',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
            ),
        ],
      ),
    );
  }
}

class _ChannelMixBar extends StatelessWidget {
  const _ChannelMixBar({
    required this.label,
    required this.share,
    required this.amount,
    required this.color,
  });

  final String label;
  final double share;
  final double amount;
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
              '${(share * 100).toStringAsFixed(0)}% · ${formatCurrencyCompact(amount)}',
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

double? _deltaPercent(double current, double previous) {
  if (previous == 0) return null;
  return ((current - previous) / previous) * 100;
}

Rect _shareOrigin(BuildContext context) {
  final box = context.findRenderObject() as RenderBox?;
  if (box == null) return Rect.zero;
  final origin = box.localToGlobal(Offset.zero) & box.size;
  return origin;
}
