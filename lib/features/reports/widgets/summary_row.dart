import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

class SummaryRow extends StatelessWidget {
  const SummaryRow({
    super.key,
    required this.total,
    required this.count,
    required this.avg,
  });

  final String total;
  final int count;
  final String avg;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        SummaryCard(
          label: AppLocalizations.of(context).reportsTotalSales,
          value: total,
          color: colorScheme.primaryContainer,
        ),
        const SizedBox(width: 12),
        SummaryCard(
          label: AppLocalizations.of(context).reportsTransactions,
          value: count.toString(),
          color: colorScheme.secondaryContainer,
        ),
        const SizedBox(width: 12),
        SummaryCard(
          label: AppLocalizations.of(context).reportsAvgTicket,
          value: avg,
          color: colorScheme.tertiaryContainer,
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
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: colorScheme.onSurface.withOpacity(0.7)),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ),
    );
  }
}
