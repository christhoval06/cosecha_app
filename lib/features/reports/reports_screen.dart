import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/utils/formatters.dart';
import '../../data/hive/boxes.dart';
import '../../data/models/sale_transaction.dart';
import '../../data/repositories/reports_repository.dart';
import '../../core/services/backup_service.dart';
import '../../l10n/app_localizations.dart';
import '../products/widgets/segment_tabs.dart';
import 'widgets/heatmap_card.dart';
import 'widgets/sparkline_card.dart';
import 'widgets/summary_row.dart';
import 'widgets/top_product_tile.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String _range = '1W';

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
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final repo = ReportsRepository();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.reportsTitle),
        actions: [
          IconButton(
            onPressed: () async {
              try {
                final path = await BackupService.exportToExcel();
                await Share.shareXFiles(
                  [XFile(path)],
                  sharePositionOrigin: _shareOrigin(context),
                );
              } catch (error) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.errorTitle),
                  ),
                );
              }
            },
            icon: const Icon(Icons.table_view),
          ),
        ],
      ),
      body: SafeArea(
        child: ValueListenableBuilder<Box<SaleTransaction>>(
          valueListenable:
              Hive.box<SaleTransaction>(HiveBoxes.transactions).listenable(),
          builder: (context, box, _) {
            final now = DateTime.now();
            final from = _rangeStart(now);
            final to = now;

            final total = repo.totalAmount(from, to);
            final count = repo.totalCount(from, to);
            final avg = count == 0 ? 0.0 : total / count;
            final series = repo.dailySeries(from, to);
            final heatmap = repo.dailyTotals(from, to);
            final top = repo.topProducts(from, to, limit: 5);
            final rangeDuration = to.difference(from);
            final prevFrom = from.subtract(rangeDuration);
            final prevTo = from;
            final prevTotal = repo.totalAmount(prevFrom, prevTo);
            final changePercent =
                prevTotal == 0 ? null : ((total - prevTotal) / prevTotal) * 100;

            if (count == 0) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    l10n.reportsTopEmpty,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: colorScheme.onSurface.withOpacity(0.6)),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                SegmentTabs(
                  value: _range,
                  onChanged: (value) => setState(() => _range = value),
                  options: const ['1D', '1W', '1M', '3M', '6M', '1Y'],
                ),
                const SizedBox(height: 16),
                SummaryRow(
                  total: formatCurrency(total),
                  count: count,
                  avg: formatCurrency(avg),
                ),
                const SizedBox(height: 16),
                SparklineCard(
                  title: l10n.reportsTotalSales,
                  totalLabel: formatCurrency(total),
                  changePercent: changePercent,
                  values: series,
                  from: from,
                  to: to,
                ),
                const SizedBox(height: 16),
                HeatmapCard(
                  totals: heatmap,
                  to: to,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.reportsTopProducts,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                if (top.isEmpty)
                  Text(
                    l10n.reportsTopEmpty,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: colorScheme.onSurface.withOpacity(0.6)),
                  )
                else
                  ...top.map(
                    (t) => TopProductTile(item: t),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

Rect _shareOrigin(BuildContext context) {
  final box = context.findRenderObject() as RenderBox?;
  if (box == null) return Rect.zero;
  final origin = box.localToGlobal(Offset.zero) & box.size;
  return origin;
}
