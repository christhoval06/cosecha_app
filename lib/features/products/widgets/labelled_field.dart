import 'package:flutter/material.dart';

class LabelledField extends StatelessWidget {
  const LabelledField({
    super.key,
    required this.label,
    required this.child,
  });

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context)
        .textTheme
        .labelLarge
        ?.copyWith(letterSpacing: 1.1);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: textStyle),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
