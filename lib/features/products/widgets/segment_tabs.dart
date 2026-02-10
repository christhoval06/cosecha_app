import 'package:flutter/material.dart';

class SegmentTabs extends StatelessWidget {
  const SegmentTabs({
    super.key,
    required this.value,
    required this.onChanged,
    required this.options,
    this.labelBuilder,
  });

  final String value;
  final ValueChanged<String> onChanged;
  final List<String> options;
  final String Function(String option)? labelBuilder;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: options.map((option) {
          final isActive = option == value;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(option),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isActive
                      ? colorScheme.primary
                      : colorScheme.surface.withValues(alpha: 0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  labelBuilder?.call(option) ?? option,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: isActive
                            ? colorScheme.onPrimary
                            : colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
