import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../widgets/reports_dashboard_panels.dart';
import 'report_filters.dart';

class ReportsDashboardWidgetDef {
  const ReportsDashboardWidgetDef({
    required this.id,
    required this.title,
    required this.builder,
  });

  final String id;
  final String Function(AppLocalizations l10n) title;
  final Widget Function(ReportFilters filters) builder;
}

class ReportsDashboardWidgetIds {
  static const summary = 'summary';
  static const periodComparison = 'period_comparison';
  static const totalSalesTrend = 'total_sales_trend';
  static const channelMix = 'channel_mix';
  static const monthlySales = 'monthly_sales';
  static const dailyHeatmap = 'daily_heatmap';
  static const topProducts = 'top_products';
  static const bottomProducts = 'bottom_products';
  static const exportTools = 'export_tools';
}

List<ReportsDashboardWidgetDef> reportsDashboardRegistry({
  bool includePremium = true,
}) {
  final widgets = <ReportsDashboardWidgetDef>[
    ReportsDashboardWidgetDef(
      id: ReportsDashboardWidgetIds.summary,
      title: _summaryTitle,
      builder: ReportsSummaryPanel.new,
    ),
    ReportsDashboardWidgetDef(
      id: ReportsDashboardWidgetIds.periodComparison,
      title: _periodComparisonTitle,
      builder: ReportsPeriodComparisonPanel.new,
    ),
    ReportsDashboardWidgetDef(
      id: ReportsDashboardWidgetIds.totalSalesTrend,
      title: _totalSalesTrendTitle,
      builder: ReportsTotalSalesTrendPanel.new,
    ),
    ReportsDashboardWidgetDef(
      id: ReportsDashboardWidgetIds.channelMix,
      title: _channelMixTitle,
      builder: ReportsChannelMixPanel.new,
    ),
    ReportsDashboardWidgetDef(
      id: ReportsDashboardWidgetIds.monthlySales,
      title: _monthlySalesTitle,
      builder: ReportsMonthlySalesPanel.new,
    ),
    ReportsDashboardWidgetDef(
      id: ReportsDashboardWidgetIds.dailyHeatmap,
      title: _dailyHeatmapTitle,
      builder: ReportsHeatmapPanel.new,
    ),
    ReportsDashboardWidgetDef(
      id: ReportsDashboardWidgetIds.topProducts,
      title: _topProductsTitle,
      builder: ReportsTopProductsPanel.new,
    ),
    ReportsDashboardWidgetDef(
      id: ReportsDashboardWidgetIds.bottomProducts,
      title: _bottomProductsTitle,
      builder: ReportsBottomProductsPanel.new,
    ),
  ];
  if (includePremium) {
    widgets.add(
      const ReportsDashboardWidgetDef(
        id: ReportsDashboardWidgetIds.exportTools,
        title: _exportToolsTitle,
        builder: ReportsExportToolsPanel.new,
      ),
    );
  }
  return widgets;
}

String _exportToolsTitle(AppLocalizations l10n) =>
    l10n.reportsWidgetExportTools;
String _summaryTitle(AppLocalizations l10n) => l10n.reportsWidgetSummary;
String _periodComparisonTitle(AppLocalizations l10n) =>
    l10n.reportsWidgetPeriodComparison;
String _totalSalesTrendTitle(AppLocalizations l10n) =>
    l10n.reportsWidgetTotalSalesTrend;
String _channelMixTitle(AppLocalizations l10n) => l10n.reportsWidgetChannelMix;
String _monthlySalesTitle(AppLocalizations l10n) =>
    l10n.reportsWidgetMonthlySales;
String _dailyHeatmapTitle(AppLocalizations l10n) =>
    l10n.reportsWidgetDailyHeatmap;
String _topProductsTitle(AppLocalizations l10n) =>
    l10n.reportsWidgetTopProducts;
String _bottomProductsTitle(AppLocalizations l10n) =>
    l10n.reportsWidgetBottomProducts;
