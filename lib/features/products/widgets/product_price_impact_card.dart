import 'package:flutter/material.dart';

import '../../../core/utils/formatters.dart';

class ProductPriceImpactCard extends StatelessWidget {
  const ProductPriceImpactCard({
    super.key,
    required this.title,
    required this.previousPrice,
    required this.currentPrice,
    required this.deltaLabel,
    required this.percentLabel,
    required this.unitsLabel,
    this.estimatedUnits = 10,
  });

  final String title;
  final double previousPrice;
  final double currentPrice;
  final String deltaLabel;
  final String percentLabel;
  final int estimatedUnits;
  final String Function(int units) unitsLabel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final shadowColor = Theme.of(context).shadowColor;
    final delta = currentPrice - previousPrice;
    final deltaPercent = previousPrice <= 0
        ? null
        : ((currentPrice - previousPrice) / previousPrice) * 100;
    final revenueDelta = delta * estimatedUnits;
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
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ImpactMetric(
                  label: deltaLabel,
                  value:
                      '${positive ? '+' : ''}${formatCurrency(delta)}',
                ),
              ),
              Expanded(
                child: _ImpactMetric(
                  label: percentLabel,
                  value: deltaPercent == null
                      ? '--'
                      : '${deltaPercent >= 0 ? '+' : ''}${deltaPercent.toStringAsFixed(1)}%',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            unitsLabel(estimatedUnits),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
          ),
          const SizedBox(height: 4),
          Text(
            '${revenueDelta >= 0 ? '+' : ''}${formatCurrency(revenueDelta)}',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: positive ? colorScheme.primary : colorScheme.error,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}

class _ImpactMetric extends StatelessWidget {
  const _ImpactMetric({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.65),
              ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}
