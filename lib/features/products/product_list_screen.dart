import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../core/widgets/list_empty_state.dart';
import '../../core/utils/formatters.dart';
import '../../core/constants/app_routes.dart';
import '../../data/hive/boxes.dart';
import '../../data/models/product.dart';
import '../../l10n/app_localizations.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.productsTitle)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.productEdit);
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: ValueListenableBuilder<Box<Product>>(
          valueListenable: Hive.box<Product>(HiveBoxes.products).listenable(),
          builder: (context, box, _) {
            final items = box.values.toList();
            if (items.isEmpty) {
              return ListEmptyState(
                icon: Icons.inventory_2_outlined,
                title: l10n.productsEmptyTitle,
                description: l10n.productsEmptyDescription,
                actionLabel: l10n.productsEmptyAction,
                onAction: () {
                  Navigator.of(context).pushNamed(AppRoutes.productEdit);
                },
              );
            }

            final filtered = items.where((product) {
              final matchesName = product.name.toLowerCase().contains(
                _query.toLowerCase(),
              );
              return matchesName;
            }).toList();

            return Column(
              children: [
                _Filters(
                  query: _query,
                  onQueryChanged: (value) => setState(() => _query = value),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemBuilder: (context, index) {
                      final product = filtered[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        tileColor: colorScheme.surface,
                        leading: CircleAvatar(
                          backgroundColor: colorScheme.primaryContainer,
                          backgroundImage: product.imageUrl.isNotEmpty
                              ? FileImage(File(product.imageUrl))
                              : null,
                          child: product.imageUrl.isEmpty
                              ? const Icon(Icons.inventory_2_outlined)
                              : null,
                        ),
                        title: Text(product.name),
                  subtitle: Text(
                    product.formatAmount(),
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.of(
                            context,
                          ).pushNamed(AppRoutes.productEdit, arguments: product);
                        },
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemCount: filtered.length,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Filters extends StatelessWidget {
  const _Filters({
    required this.query,
    required this.onQueryChanged,
  });

  final String query;
  final ValueChanged<String> onQueryChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        children: [
          TextField(
            onChanged: onQueryChanged,
            decoration: InputDecoration(
              hintText: l10n.productsSearchHint,
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
