import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/services.dart';

import '../../core/widgets/form_builder_currency_field.dart';
import '../../core/widgets/list_empty_state.dart';
import '../../core/widgets/list_picker_sheet.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/sales_channels.dart';
import '../../core/utils/formatters.dart';
import '../../data/hive/boxes.dart';
import '../../data/models/product.dart';
import '../../data/models/sale_transaction.dart';
import '../../data/repositories/sales_repository.dart';
import '../../l10n/app_localizations.dart';

class AddSaleScreen extends StatefulWidget {
  const AddSaleScreen({super.key, this.product});

  final Product? product;

  @override
  State<AddSaleScreen> createState() => _AddSaleScreenState();
}

class _AddSaleScreenState extends State<AddSaleScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _repository = SalesRepository();
  bool _saving = false;
  String? _selectedProductId;

  @override
  void initState() {
    super.initState();
    _selectedProductId = widget.product?.id;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.salesAddTitle)),
      body: SafeArea(
        child: ValueListenableBuilder<Box<Product>>(
          valueListenable: Hive.box<Product>(HiveBoxes.products).listenable(),
          builder: (context, box, _) {
            final products = box.values.toList();
            if (products.isEmpty && widget.product == null) {
              return ListEmptyState(
                icon: Icons.inventory_2_outlined,
                title: l10n.productsEmptyTitle,
                description: l10n.productsEmptyDescription,
                actionLabel: l10n.productsEmptyAction,
                onAction: () =>
                    Navigator.of(context).pushNamed(AppRoutes.products),
              );
            }

            return FormBuilder(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  FormBuilderField<String>(
                    name: 'product_id',
                    initialValue: _selectedProductId,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.salesProductNameRequired;
                      }
                      return null;
                    },
                    builder: (field) {
                      final selected = field.value == null
                          ? null
                          : products.firstWhere(
                              (p) => p.id == field.value,
                              orElse: () => products.first,
                            );
                      return _ProductSelectorCard(
                        title: l10n.salesProductName,
                        product: selected,
                        emptyLabel: l10n.salesProductSelect,
                        changeLabel: l10n.salesChangeProduct,
                        onTap: () async {
                          final picked = await ListPickerSheet.show<Product>(
                            context: context,
                            title: l10n.salesProductName,
                            items: products,
                            labelBuilder: (item) => item.name,
                            searchHint: l10n.salesSearchHint,
                          );
                          if (picked != null) {
                            setState(() => _selectedProductId = picked.id);
                            field.didChange(picked.id);
                          }
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  FormBuilderTextField(
                    name: 'quantity',
                    decoration: InputDecoration(labelText: l10n.salesQuantity),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      final parsed = int.tryParse(value ?? '');
                      if (parsed == null || parsed <= 0) {
                        return l10n.salesQuantityRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  FormBuilderCurrencyField(
                    name: 'amount',
                    labelText: l10n.salesAmount,
                    validator: (value) {
                      final parsed = _parseAmountInput(value);
                      if (parsed == null || parsed <= 0) {
                        return l10n.salesAmountRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  FormBuilderDropdown<String>(
                    name: 'channel',
                    initialValue: SalesChannels.retail,
                    decoration: InputDecoration(labelText: l10n.salesChannel),
                    items: [
                      DropdownMenuItem(
                        value: SalesChannels.retail,
                        child: Text(l10n.salesChannelRetail),
                      ),
                      DropdownMenuItem(
                        value: SalesChannels.wholesale,
                        child: Text(l10n.salesChannelWholesale),
                      ),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.salesChannelRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _saving ? null : _saveSale,
                      child: Text(_saving ? l10n.salesSaving : l10n.salesSave),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _saveSale() async {
    if (_saving) return;
    final l10n = AppLocalizations.of(context);

    final formState = _formKey.currentState;
    if (formState == null) return;

    final isValid = formState.saveAndValidate();
    if (!isValid) return;

    setState(() => _saving = true);
    final values = formState.value;
    final selectedId = (values['product_id'] as String?) ?? widget.product?.id;
    final selectedProduct = selectedId == null
        ? null
        : Hive.box<Product>(HiveBoxes.products).get(selectedId);

    if (selectedProduct == null) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.salesProductNameRequired)));
      return;
    }

    final sale = SaleTransaction(
      id: '',
      productId: selectedProduct.id,
      productName: selectedProduct.name,
      amount: _parseAmountInput(values['amount'] as String?) ?? 0,
      quantity: int.parse(values['quantity'] as String),
      channel: values['channel'] as String,
      createdAt: DateTime.now(),
    );

    try {
      await _repository.save(sale);
      if (!mounted) return;
      setState(() => _saving = false);
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${l10n.salesSaveError}: $e')));
    }
  }

  double? _parseAmountInput(String? raw) {
    return parseCurrencyInput(raw);
  }
}

class _ProductSelectorCard extends StatelessWidget {
  const _ProductSelectorCard({
    required this.title,
    required this.emptyLabel,
    required this.onTap,
    this.product,
    this.changeLabel,
  });

  final String title;
  final String emptyLabel;
  final Product? product;
  final VoidCallback? onTap;
  final String? changeLabel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final label = product?.name ?? emptyLabel;
    final productImagePath = product?.imageUrl ?? '';
    final hasValidImage =
        productImagePath.isNotEmpty && File(productImagePath).existsSync();
    return Card(
      elevation: 0,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: colorScheme.primaryContainer,
                backgroundImage: hasValidImage
                    ? FileImage(File(productImagePath))
                    : null,
                child: !hasValidImage
                    ? const Icon(Icons.inventory_2_outlined)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              if (product != null) ...[
                Text(
                  product!.formatAmount(),
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(color: colorScheme.primary),
                ),
                if (onTap != null && changeLabel != null) ...[
                  const SizedBox(width: 8),
                  Text(
                    changeLabel!,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ],
              const SizedBox(width: 8),
              if (onTap != null) const Icon(Icons.expand_more),
            ],
          ),
        ),
      ),
    );
  }
}
