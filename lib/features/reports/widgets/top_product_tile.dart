import 'package:flutter/material.dart';

import '../../../core/utils/formatters.dart';
import '../../../data/repositories/reports_repository.dart';
import '../../../l10n/app_localizations.dart';

class TopProductTile extends StatelessWidget {
  const TopProductTile({super.key, required this.item});

  final TopProduct item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 4),
                Text(
                  '${item.quantity} · ${AppLocalizations.of(context).reportsUnits}',
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: colorScheme.onSurface.withOpacity(0.6)),
                ),
              ],
            ),
          ),
          Text(
            formatCurrency(item.amount),
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(color: colorScheme.primary),
          ),
        ],
      ),
    );
  }
}
