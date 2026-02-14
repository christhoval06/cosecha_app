import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../widgets/home_dashboard_panels.dart';

class HomeDashboardWidgetDef {
  const HomeDashboardWidgetDef({
    required this.id,
    required this.title,
    required this.builder,
  });

  final String id;
  final String Function(AppLocalizations l10n) title;
  final WidgetBuilder builder;
}

class HomeDashboardWidgetIds {
  static const performance = 'performance';
  static const quickActions = 'quick_actions';
  static const salesGoal = 'sales_goal';
  static const channelMix = 'channel_mix';
  static const avgTicketTrend = 'avg_ticket_trend';
  static const productsAtRisk = 'products_at_risk';
  static const weeklyActivity = 'weekly_activity';
  static const weeklyInsights = 'weekly_insights';
  static const quickSale = 'quick_sale';
  static const latestProducts = 'latest_products';
  static const recentSales = 'recent_sales';
}

List<HomeDashboardWidgetDef> homeDashboardRegistry() {
  return const [
    HomeDashboardWidgetDef(
      id: HomeDashboardWidgetIds.performance,
      title: _performanceTitle,
      builder: _buildPerformancePanel,
    ),
    HomeDashboardWidgetDef(
      id: HomeDashboardWidgetIds.quickActions,
      title: _quickActionsTitle,
      builder: _buildQuickActionsPanel,
    ),
    HomeDashboardWidgetDef(
      id: HomeDashboardWidgetIds.salesGoal,
      title: _salesGoalTitle,
      builder: _buildSalesGoalPanel,
    ),
    HomeDashboardWidgetDef(
      id: HomeDashboardWidgetIds.channelMix,
      title: _channelMixTitle,
      builder: _buildChannelMixPanel,
    ),
    HomeDashboardWidgetDef(
      id: HomeDashboardWidgetIds.avgTicketTrend,
      title: _avgTicketTrendTitle,
      builder: _buildAvgTicketTrendPanel,
    ),
    HomeDashboardWidgetDef(
      id: HomeDashboardWidgetIds.productsAtRisk,
      title: _productsAtRiskTitle,
      builder: _buildProductsAtRiskPanel,
    ),
    HomeDashboardWidgetDef(
      id: HomeDashboardWidgetIds.weeklyActivity,
      title: _weeklyActivityTitle,
      builder: _buildWeeklyActivityPanel,
    ),
    HomeDashboardWidgetDef(
      id: HomeDashboardWidgetIds.weeklyInsights,
      title: _weeklyInsightsTitle,
      builder: _buildWeeklyInsightsPanel,
    ),
    HomeDashboardWidgetDef(
      id: HomeDashboardWidgetIds.quickSale,
      title: _quickSaleTitle,
      builder: _buildQuickSalePanel,
    ),
    HomeDashboardWidgetDef(
      id: HomeDashboardWidgetIds.latestProducts,
      title: _latestProductsTitle,
      builder: _buildLatestProductsPanel,
    ),
    HomeDashboardWidgetDef(
      id: HomeDashboardWidgetIds.recentSales,
      title: _recentSalesTitle,
      builder: _buildRecentSalesPanel,
    ),
  ];
}

String _performanceTitle(AppLocalizations l10n) => l10n.homePerformanceOverview;
String _quickActionsTitle(AppLocalizations l10n) => l10n.homeWidgetQuickActions;
String _salesGoalTitle(AppLocalizations l10n) => l10n.homeWidgetSalesGoal;
String _channelMixTitle(AppLocalizations l10n) => l10n.homeWidgetChannelMix;
String _avgTicketTrendTitle(AppLocalizations l10n) =>
    l10n.homeWidgetAvgTicketTrend;
String _productsAtRiskTitle(AppLocalizations l10n) =>
    l10n.homeWidgetProductsAtRisk;
String _weeklyActivityTitle(AppLocalizations l10n) =>
    l10n.homeWidgetWeeklyActivity;
String _weeklyInsightsTitle(AppLocalizations l10n) =>
    l10n.homeWidgetWeeklyInsights;
String _quickSaleTitle(AppLocalizations l10n) => l10n.homeQuickSale;
String _latestProductsTitle(AppLocalizations l10n) =>
    l10n.homeLatestProductsTitle;
String _recentSalesTitle(AppLocalizations l10n) => l10n.homeRecentSales;

Widget _buildPerformancePanel(BuildContext context) =>
    const HomePerformancePanel();
Widget _buildQuickActionsPanel(BuildContext context) =>
    const HomeQuickActionsPanel();
Widget _buildSalesGoalPanel(BuildContext context) => const HomeSalesGoalPanel();
Widget _buildChannelMixPanel(BuildContext context) =>
    const HomeChannelMixPanel();
Widget _buildAvgTicketTrendPanel(BuildContext context) =>
    const HomeAvgTicketTrendPanel();
Widget _buildProductsAtRiskPanel(BuildContext context) =>
    const HomeProductsAtRiskPanel();
Widget _buildWeeklyActivityPanel(BuildContext context) =>
    const HomeWeeklyActivityPanel();
Widget _buildWeeklyInsightsPanel(BuildContext context) =>
    const HomeWeeklyInsightsPanel();
Widget _buildQuickSalePanel(BuildContext context) => const HomeQuickSalePanel();
Widget _buildLatestProductsPanel(BuildContext context) =>
    const HomeLatestProductsPanel();
Widget _buildRecentSalesPanel(BuildContext context) =>
    const HomeRecentSalesPanel();
