import 'package:flutter/material.dart';

class ProductStrategyTagsPicker extends StatelessWidget {
  const ProductStrategyTagsPicker({
    super.key,
    required this.title,
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  final String title;
  final List<String> options;
  final Set<String> selected;
  final ValueChanged<Set<String>> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final option in options)
              FilterChip(
                label: Text(option),
                selected: selected.contains(option),
                onSelected: (value) {
                  final next = Set<String>.from(selected);
                  if (value) {
                    next.add(option);
                  } else {
                    next.remove(option);
                  }
                  onChanged(next);
                },
              ),
          ],
        ),
      ],
    );
  }
}
