import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/hive/boxes.dart';
import '../../data/models/sale_transaction.dart';
import '../../core/premium/premium_access.dart';
import '../../core/premium/premium_features.dart';
import '../../core/premium/premium_guard.dart';
import '../../l10n/app_localizations.dart';
import '../products/widgets/segment_tabs.dart';
import 'dashboard/report_filters.dart';
import 'dashboard/reports_dashboard_config.dart';
import 'dashboard/reports_dashboard_customize_sheet.dart';
import 'dashboard/reports_dashboard_registry.dart';
import 'widgets/reports_filters_sheet.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String _range = '1W';
  String? _channelFilter;
  String? _productIdFilter;
  double? _minAmountFilter;
  double? _maxAmountFilter;
  int? _minQuantityFilter;
  late final ReportsDashboardConfigStore _configStore;
  late final List<ReportsDashboardWidgetDef> _registry;
  ReportsDashboardConfig? _layout;
  bool _loadingLayout = true;

  DateTime _rangeStart(DateTime now) {
    switch (_range) {
      case '1D':
        return now.subtract(const Duration(days: 1));
      case '1M':
        return now.subtract(const Duration(days: 30));
      case '3M':
        return now.subtract(const Duration(days: 90));
      case '6M':
        return now.subtract(const Duration(days: 180));
      case '1Y':
        return now.subtract(const Duration(days: 365));
      case '1W':
      default:
        return now.subtract(const Duration(days: 7));
    }
  }

  @override
  void initState() {
    super.initState();
    _configStore = ReportsDashboardConfigStore();
    _registry = reportsDashboardRegistry(
      includePremium: PremiumAccess.instance.isPremium,
    );
    _loadLayout();
  }

  Future<void> _loadLayout() async {
    final defaults = _registry.map((item) => item.id).toList();
    final defaultEnabled = <String>[
      ReportsDashboardWidgetIds.summary,
      ReportsDashboardWidgetIds.periodComparison,
      ReportsDashboardWidgetIds.totalSalesTrend,
      ReportsDashboardWidgetIds.channelMix,
      ReportsDashboardWidgetIds.monthlySales,
      ReportsDashboardWidgetIds.topProducts,
      if (PremiumAccess.instance.isPremium) ReportsDashboardWidgetIds.exportTools,
    ];
    final loaded = await _configStore.load(
      defaults,
      defaultEnabledWidgetIds: defaultEnabled,
    );
    final availableIds = defaults.toSet();
    final sanitized = ReportsDashboardConfig(
      enabledWidgetIds: loaded.enabledWidgetIds
          .where(availableIds.contains)
          .toList(growable: false),
      orderedWidgetIds: loaded.orderedWidgetIds
          .where(availableIds.contains)
          .toList(growable: false),
    );
    if (!mounted) return;
    setState(() {
      _layout = sanitized;
      _loadingLayout = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();
    final filters = ReportFilters(
      range: _range,
      from: _rangeStart(now),
      to: now,
      channel: _channelFilter,
      productId: _productIdFilter,
      minAmount: _minAmountFilter,
      maxAmount: _maxAmountFilter,
      minQuantity: _minQuantityFilter,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.reportsTitle),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                onPressed: _openAdvancedFilters,
                icon: const Icon(Icons.filter_list),
              ),
              if (filters.activeCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      filters.activeCount.toString(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 10,
                          ),
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            onPressed: _layout == null
                ? null
                : () async {
                    final canUse = await guardPremiumAccess(
                      context,
                      feature: PremiumFeature.reportsDashboardCustomization,
                    );
                    if (!canUse) return;
                    await _openCustomize();
                  },
            icon: const Icon(Icons.tune),
          ),
        ],
      ),
      body: SafeArea(
        child: _loadingLayout
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  SegmentTabs(
                    value: _range,
                    onChanged: (value) => setState(() => _range = value),
                    options: const ['1D', '1W', '1M', '3M', '6M', '1Y'],
                  ),
                  const SizedBox(height: 16),
                  ..._buildDashboardWidgets(l10n, filters),
                ],
              ),
      ),
    );
  }

  List<Widget> _buildDashboardWidgets(
    AppLocalizations l10n,
    ReportFilters filters,
  ) {
    final layout = _layout;
    if (layout == null) return const [SizedBox.shrink()];

    final defsById = {
      for (final def in _registry) def.id: def,
    };

    final widgets = <Widget>[];
    for (final id in layout.orderedWidgetIds) {
      if (!layout.enabledWidgetIds.contains(id)) continue;
      final def = defsById[id];
      if (def == null) continue;
      widgets.add(def.builder(filters));
      widgets.add(const SizedBox(height: 16));
    }
    if (widgets.isNotEmpty) {
      widgets.removeLast();
    }
    if (widgets.isEmpty) {
      widgets.add(
        Text(
          l10n.reportsTopEmpty,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }
    return widgets;
  }

  Future<void> _openCustomize() async {
    final layout = _layout;
    if (layout == null) return;
    final updated = await showReportsDashboardCustomizeSheet(
      context: context,
      current: layout,
      definitions: _registry,
    );
    if (updated == null) return;
    await _configStore.save(updated);
    if (!mounted) return;
    setState(() => _layout = updated);
  }

  Future<void> _openAdvancedFilters() async {
    final allItems = Hive.box<SaleTransaction>(HiveBoxes.transactions).values;
    final products = <ReportsProductFilterOption>[
      for (final entry in {
        for (final item in allItems)
          item.productId: ReportsProductFilterOption(
            productId: item.productId,
            productName: item.productName,
          ),
      }.entries)
        if (entry.key.isNotEmpty) entry.value,
    ]..sort((a, b) => a.productName.compareTo(b.productName));

    final values = await showReportsFiltersSheet(
      context: context,
      initialChannel: _channelFilter,
      initialProductId: _productIdFilter,
      initialMinAmount: _minAmountFilter,
      initialMaxAmount: _maxAmountFilter,
      initialMinQuantity: _minQuantityFilter,
      products: products,
    );

    if (values == null) return;
    if (!mounted) return;
    setState(() {
      _channelFilter = values.channel;
      _productIdFilter = values.productId;
      _minAmountFilter = values.minAmount;
      _maxAmountFilter = values.maxAmount;
      _minQuantityFilter = values.minQuantity;
    });
  }
}
