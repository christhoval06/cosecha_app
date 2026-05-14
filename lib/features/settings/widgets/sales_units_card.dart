import 'package:flutter/material.dart';

import '../../../core/services/inventory_settings_service.dart';

class SalesUnitsCard extends StatefulWidget {
  const SalesUnitsCard({
    super.key,
    required this.title,
    required this.hint,
    required this.units,
    required this.onAdd,
    required this.onDelete,
  });

  final String title;
  final String hint;
  final List<InventoryUnit> units;
  final ValueChanged<String> onAdd;
  final ValueChanged<InventoryUnit> onDelete;

  @override
  State<SalesUnitsCard> createState() => _SalesUnitsCardState();
}

class _SalesUnitsCardState extends State<SalesUnitsCard> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void submit() {
      final value = _controller.text.trim();
      if (value.isEmpty) return;
      widget.onAdd(value);
      _controller.clear();
    }

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.units
                  .map(
                    (item) => Chip(
                      label: Text(item.label),
                      onDeleted: () => widget.onDelete(item),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              onSubmitted: (_) => submit(),
              decoration: InputDecoration(
                hintText: widget.hint,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: submit,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
