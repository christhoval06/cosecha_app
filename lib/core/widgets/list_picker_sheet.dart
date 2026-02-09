import 'package:flutter/material.dart';

class ListPickerSheet {
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required List<T> items,
    required String Function(T) labelBuilder,
    String? searchHint,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return _ListPickerSheetBody<T>(
          title: title,
          items: items,
          labelBuilder: labelBuilder,
          searchHint: searchHint,
        );
      },
    );
  }
}

class _ListPickerSheetBody<T> extends StatefulWidget {
  const _ListPickerSheetBody({
    required this.title,
    required this.items,
    required this.labelBuilder,
    this.searchHint,
  });

  final String title;
  final List<T> items;
  final String Function(T) labelBuilder;
  final String? searchHint;

  @override
  State<_ListPickerSheetBody<T>> createState() =>
      _ListPickerSheetBodyState<T>();
}

class _ListPickerSheetBodyState<T> extends State<_ListPickerSheetBody<T>> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final filtered = widget.items.where((item) {
      final label = widget.labelBuilder(item).toLowerCase();
      return label.contains(_query.toLowerCase());
    }).toList();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 12,
          bottom: MediaQuery.of(context).viewInsets.bottom + 12,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            TextField(
              onChanged: (value) => setState(() => _query = value),
              decoration: InputDecoration(
                hintText: widget.searchHint,
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = filtered[index];
                  return ListTile(
                    title: Text(widget.labelBuilder(item)),
                    onTap: () => Navigator.of(context).pop(item),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
