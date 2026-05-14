import 'package:flutter/material.dart';

class InventoryMarginSlider extends StatelessWidget {
  const InventoryMarginSlider({
    super.key,
    required this.value,
    required this.label,
    required this.onChanged,
  });

  final double value;
  final String label;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      color: scheme.surfaceContainerHighest.withValues(alpha: 0.35),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.trending_up, color: scheme.primary),
                const SizedBox(width: 8),
                Expanded(child: Text(label)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${value.toStringAsFixed(0)}%',
                    style: TextStyle(
                      color: scheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            Slider(
              value: value,
              min: 0,
              max: 200,
              divisions: 40,
              label: '${value.toStringAsFixed(0)}%',
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
