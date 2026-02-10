import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../core/widgets/list_empty_state.dart';
import '../../core/utils/formatters.dart';
import '../../core/constants/sales_channels.dart';
import '../../data/hive/boxes.dart';
import '../../data/models/sale_transaction.dart';
import '../../data/repositories/sales_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../core/constants/app_routes.dart';
import '../products/widgets/segment_tabs.dart';
import 'widgets/sales_history_filters_sheet.dart';

class SalesHistoryScreen extends StatefulWidget {
  const SalesHistoryScreen({super.key});

  @override
  State<SalesHistoryScreen> createState() => _SalesHistoryScreenState();
}

class _SalesHistoryScreenState extends State<SalesHistoryScreen> {
  String _range = '1D';
  final _repository = SalesRepository();
  SalesHistorySort _sort = SalesHistorySort.latest;
  String? _channelFilter;
  String? _productIdFilter;

  DateTime _rangeStart(DateTime now) {
    switch (_range) {
      case '1H':
        return now.subtract(const Duration(hours: 1));
      case '1W':
        return now.subtract(const Duration(days: 7));
      case '1M':
        return now.subtract(const Duration(days: 30));
      case '1D':
      default:
        final yesterday = DateTime(now.year, now.month, now.day)
            .subtract(const Duration(days: 1));
        return yesterday;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.salesHistoryTitle),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                onPressed: _openFilters,
                icon: const Icon(Icons.filter_list),
              ),
              if (_activeFilterCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _activeFilterCount.toString(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colorScheme.onPrimary,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            onPressed: _seedDemoData,
            icon: const Icon(Icons.auto_awesome),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed(AppRoutes.saleAdd),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: SegmentTabs(
                value: _range,
                options: const ['1H', '1D', '1W', '1M'],
                labelBuilder: (option) => _rangeLabel(l10n, option),
                onChanged: (value) => setState(() => _range = value),
              ),
            ),
            Expanded(
              child: ValueListenableBuilder<Box<SaleTransaction>>(
                valueListenable:
                    Hive.box<SaleTransaction>(HiveBoxes.transactions)
                        .listenable(),
                builder: (context, box, _) {
                  final now = DateTime.now();
                  final start = _rangeStart(now);
                  final items = box.values
                      .where((item) => item.createdAt.isAfter(start))
                      .toList();
                  final filteredItems = _applyFilters(items);

                  if (filteredItems.isEmpty) {
                    return ListEmptyState(
                      icon: Icons.receipt_long,
                      title: l10n.salesEmptyTitle,
                      description: l10n.salesEmptyDescription,
                      actionLabel: l10n.salesEmptyAction,
                      onAction: () =>
                          Navigator.of(context).pushNamed(AppRoutes.saleAdd),
                    );
                  }

                  final grouped = _groupByDay(filteredItems);
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: grouped.length,
                    itemBuilder: (context, index) {
                      final entry = grouped[index];
                      return _Section(
                        title: _sectionTitle(l10n, entry.date, now),
                        items: entry.items,
                        colorScheme: colorScheme,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _sectionTitle(
    AppLocalizations l10n,
    DateTime date,
    DateTime now,
  ) {
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    if (_sameDay(date, today)) return l10n.salesToday;
    if (_sameDay(date, yesterday)) return l10n.salesYesterday;
    return '${date.day}/${date.month}/${date.year}';
  }

  bool _sameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _rangeLabel(AppLocalizations l10n, String value) {
    switch (value) {
      case '1H':
        return l10n.salesRange1H;
      case '1D':
        return l10n.salesRange1D;
      case '1W':
        return l10n.salesRange1W;
      case '1M':
        return l10n.salesRange1M;
      default:
        return value;
    }
  }

  int get _activeFilterCount {
    var count = 0;
    if (_channelFilter != null) count++;
    if (_productIdFilter != null) count++;
    if (_sort != SalesHistorySort.latest) count++;
    return count;
  }

  List<SaleTransaction> _applyFilters(List<SaleTransaction> items) {
    var filtered = items.where((item) {
      if (_channelFilter != null &&
          SalesChannels.normalize(item.channel) != _channelFilter) {
        return false;
      }
      if (_productIdFilter != null && item.productId != _productIdFilter) {
        return false;
      }
      return true;
    }).toList();

    switch (_sort) {
      case SalesHistorySort.latest:
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      case SalesHistorySort.highestAmount:
        filtered.sort((a, b) => b.amount.compareTo(a.amount));
      case SalesHistorySort.highestQuantity:
        filtered.sort((a, b) => b.quantity.compareTo(a.quantity));
    }
    return filtered;
  }

  Future<void> _openFilters() async {
    final allItems = Hive.box<SaleTransaction>(HiveBoxes.transactions).values;
    final products = <ProductFilterOption>[
      for (final entry in {
        for (final item in allItems)
          item.productId: ProductFilterOption(
            productId: item.productId,
            productName: item.productName,
          ),
      }.values)
        entry,
    ]..sort((a, b) => a.productName.compareTo(b.productName));

    final values = await showSalesHistoryFiltersSheet(
      context: context,
      initialChannel: _channelFilter,
      initialProductId: _productIdFilter,
      initialSort: _sort,
      products: products,
    );

    if (values == null) return;

    if (!mounted) return;
    setState(() {
      _channelFilter = values.channel;
      _productIdFilter = values.productId;
      _sort = values.sort;
    });
  }

  List<_DayGroup> _groupByDay(List<SaleTransaction> items) {
    final Map<DateTime, List<SaleTransaction>> map = {};
    for (final item in items) {
      final key = DateTime(item.createdAt.year, item.createdAt.month,
          item.createdAt.day);
      map.putIfAbsent(key, () => []).add(item);
    }
    final groups = map.entries
        .map((e) => _DayGroup(date: e.key, items: e.value))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    return groups;
  }

  Future<void> _seedDemoData() async {
    final now = DateTime.now();
    final samples = [
      SaleTransaction(
        id: '',
        productId: 'demo_1',
        productName: 'Sandía',
        amount: 120.00,
        quantity: 4,
        channel: SalesChannels.retail,
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
      SaleTransaction(
        id: '',
        productId: 'demo_2',
        productName: 'Mango',
        amount: 32.50,
        quantity: 1,
        channel: SalesChannels.wholesale,
        createdAt: now.subtract(const Duration(hours: 5)),
      ),
      SaleTransaction(
        id: '',
        productId: 'demo_3',
        productName: 'Papaya',
        amount: 189.00,
        quantity: 2,
        channel: SalesChannels.retail,
        createdAt: now.subtract(const Duration(days: 1, hours: 3)),
      ),
      SaleTransaction(
        id: '',
        productId: 'demo_4',
        productName: 'Fresa',
        amount: 450.00,
        quantity: 10,
        channel: SalesChannels.wholesale,
        createdAt: now.subtract(const Duration(days: 7, hours: 4)),
      ),
    ];

    for (final sale in samples) {
      await _repository.save(sale);
    }
  }
}

class _DayGroup {
  _DayGroup({required this.date, required this.items});

  final DateTime date;
  final List<SaleTransaction> items;
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.items,
    required this.colorScheme,
  });

  final String title;
  final List<SaleTransaction> items;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(color: colorScheme.onPrimaryContainer),
          ),
        ),
        ...items.map((item) => _SaleTile(item: item)),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _SaleTile extends StatelessWidget {
  const _SaleTile({required this.item});

  final SaleTransaction item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final shadowColor = Theme.of(context).shadowColor;
    final l10n = AppLocalizations.of(context);
    final channelLabel = _channelLabel(l10n, item.channel);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.productName,
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 4),
                  Text(
                    '${l10n.salesQuantity}: ${item.quantity} · $channelLabel',
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.6)),
                  ),
                ],
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.formatAmount(),
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: colorScheme.primary),
              ),
              const SizedBox(height: 4),
              Text(
                _formatTime(item.createdAt),
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.6)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _channelLabel(AppLocalizations l10n, String value) {
    switch (SalesChannels.normalize(value)) {
      case SalesChannels.retail:
        return l10n.salesChannelRetail;
      case SalesChannels.wholesale:
        return l10n.salesChannelWholesale;
      default:
        return value;
    }
  }
}
