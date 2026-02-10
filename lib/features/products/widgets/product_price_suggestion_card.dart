import 'package:flutter/material.dart';

import '../../../core/utils/formatters.dart';

class ProductPriceSuggestionCard extends StatelessWidget {
  const ProductPriceSuggestionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.currentPrice,
    required this.suggestedPrice,
    required this.applyLabel,
    required this.onApply,
  });

  final String title;
  final String subtitle;
  final double currentPrice;
  final double suggestedPrice;
  final String applyLabel;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final shadowColor = Theme.of(context).shadowColor;
    final delta = suggestedPrice - currentPrice;
    final positive = delta >= 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  formatCurrency(suggestedPrice),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: positive
                      ? colorScheme.secondaryContainer
                      : colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${positive ? '+' : ''}${formatCurrency(delta)}',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: positive
                            ? colorScheme.onSecondaryContainer
                            : colorScheme.onErrorContainer,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton(
              onPressed: onApply,
              child: Text(applyLabel),
            ),
          ),
        ],
      ),
    );
  }
}
