import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/formatters.dart';
import '../../../data/models/product_price_history.dart';

class ProductPriceHistoryCompact extends StatelessWidget {
  const ProductPriceHistoryCompact({
    super.key,
    required this.title,
    required this.entries,
    required this.emptyLabel,
    required this.deltaLabel,
  });

  final String title;
  final List<ProductPriceHistory> entries;
  final String emptyLabel;
  final String deltaLabel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context).toString();
    final last = entries.reversed.take(5).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          if (last.isEmpty)
            Text(
              emptyLabel,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
            )
          else
            ...List.generate(last.length, (index) {
              final item = last[index];
              final prev = index + 1 < last.length ? last[index + 1] : null;
              final delta = prev == null ? null : item.price - prev.price;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        DateFormat.yMMMd(locale).add_Hm().format(item.recordedAt),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                      ),
                    ),
                    Text(
                      formatCurrency(item.price),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      delta == null
                          ? '--'
                          : '$deltaLabel ${delta >= 0 ? '+' : ''}${formatCurrency(delta)}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: delta == null
                                ? colorScheme.onSurface.withValues(alpha: 0.5)
                                : delta >= 0
                                    ? colorScheme.primary
                                    : colorScheme.error,
                          ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}
