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

class SalesHistoryScreen extends StatefulWidget {
  const SalesHistoryScreen({super.key});

  @override
  State<SalesHistoryScreen> createState() => _SalesHistoryScreenState();
}

class _SalesHistoryScreenState extends State<SalesHistoryScreen> {
  String _range = '1D';
  final _repository = SalesRepository();

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
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_list),
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
              child: SegmentedButton<String>(
                segments: [
                  ButtonSegment(value: '1H', label: Text(l10n.salesRange1H)),
                  ButtonSegment(value: '1D', label: Text(l10n.salesRange1D)),
                  ButtonSegment(value: '1W', label: Text(l10n.salesRange1W)),
                  ButtonSegment(value: '1M', label: Text(l10n.salesRange1M)),
                ],
                selected: {_range},
                onSelectionChanged: (values) {
                  setState(() => _range = values.first);
                },
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
                      .toList()
                    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

                  if (items.isEmpty) {
                    return ListEmptyState(
                      icon: Icons.receipt_long,
                      title: l10n.salesEmptyTitle,
                      description: l10n.salesEmptyDescription,
                      actionLabel: l10n.salesEmptyAction,
                      onAction: () =>
                          Navigator.of(context).pushNamed(AppRoutes.saleAdd),
                    );
                  }

                  final grouped = _groupByDay(items);
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
            color: shadowColor.withOpacity(0.04),
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
                            color: colorScheme.onSurface.withOpacity(0.6)),
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
                    ?.copyWith(color: colorScheme.onSurface.withOpacity(0.6)),
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
