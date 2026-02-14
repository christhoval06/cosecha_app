import 'package:flutter/material.dart';

import 'app_sheet.dart';

class ListPickerSheet {
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required List<T> items,
    required String Function(T) labelBuilder,
    String? searchHint,
  }) {
    return showAppSheet<T>(
      context: context,
      isScrollControlled: true,
      title: title,
      mainAxisSize: MainAxisSize.min,
      paddingBuilder: (context) {
        return EdgeInsets.only(
          left: 16,
          right: 16,
          top: 12,
          bottom: MediaQuery.of(context).viewInsets.bottom + 12,
        );
      },
      contentBuilder: (context) {
        return [
          _ListPickerSheetBody<T>(
            items: items,
            labelBuilder: labelBuilder,
            searchHint: searchHint,
          ),
        ];
      },
    );
  }
}

class _ListPickerSheetBody<T> extends StatefulWidget {
  const _ListPickerSheetBody({
    required this.items,
    required this.labelBuilder,
    this.searchHint,
  });

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

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
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
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 360),
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: filtered.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
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
    );
  }
}
