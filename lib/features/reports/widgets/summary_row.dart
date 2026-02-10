import 'package:flutter/material.dart';

import '../../../core/utils/formatters.dart';
import '../../../l10n/app_localizations.dart';

class SummaryRow extends StatelessWidget {
  const SummaryRow({
    super.key,
    required this.total,
    required this.count,
    required this.avg,
  });

  final double total;
  final int count;
  final double avg;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: SummaryCard(
            label: AppLocalizations.of(context).reportsTotalSales,
            value: formatCurrencyCompact(total),
            color: colorScheme.primaryContainer,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SummaryCard(
            label: AppLocalizations.of(context).reportsTransactions,
            value: count.toString(),
            color: colorScheme.secondaryContainer,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SummaryCard(
            label: AppLocalizations.of(context).reportsAvgTicket,
            value: formatCurrencyCompact(avg),
            color: colorScheme.tertiaryContainer,
          ),
        ),
      ],
    );
  }
}

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 92,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ),
    );
  }
}
