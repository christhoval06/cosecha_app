import 'package:flutter/material.dart';

class InventoryPricePreviewCard extends StatelessWidget {
  const InventoryPricePreviewCard({
    super.key,
    required this.title,
    required this.purchaseLabel,
    required this.suggestedLabel,
    required this.purchaseValue,
    required this.suggestedValue,
  });

  final String title;
  final String purchaseLabel;
  final String suggestedLabel;
  final String purchaseValue;
  final String suggestedValue;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      color: scheme.secondaryContainer.withValues(alpha: 0.45),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: textTheme.titleSmall),
            const SizedBox(height: 8),
            _Row(label: purchaseLabel, value: purchaseValue),
            const SizedBox(height: 6),
            _Row(label: suggestedLabel, value: suggestedValue, highlight: true),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(child: Text(label)),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: highlight ? scheme.primary : scheme.onSurface,
          ),
        ),
      ],
    );
  }
}
