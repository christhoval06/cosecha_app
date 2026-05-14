import 'package:flutter/material.dart';

class InventoryToggleTile extends StatelessWidget {
  const InventoryToggleTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        title: Text(title, style: theme.textTheme.titleSmall),
        subtitle: Text(subtitle),
        secondary: const Icon(Icons.inventory_2_outlined),
      ),
    );
  }
}
