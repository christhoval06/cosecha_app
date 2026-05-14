import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../core/services/inventory_settings_service.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/form_builder_currency_field.dart';
import '../../../data/models/inventory_entry.dart';
import '../../../l10n/app_localizations.dart';
import 'inventory_margin_slider.dart';
import 'inventory_price_preview_card.dart';

class InventoryEntrySheet extends StatefulWidget {
  const InventoryEntrySheet({
    super.key,
    required this.productId,
    required this.productName,
    required this.units,
    required this.onSave,
    required this.quantityLabel,
    required this.purchasePriceLabel,
    required this.saveLabel,
  });
  final String productId;
  final String productName;
  final List<InventoryUnit> units;
  final ValueChanged<InventoryEntry> onSave;
  final String quantityLabel;
  final String purchasePriceLabel;
  final String saveLabel;

  @override
  State<InventoryEntrySheet> createState() => _InventoryEntrySheetState();
}

class _InventoryEntrySheetState extends State<InventoryEntrySheet> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _purchaseController = TextEditingController();
  double _margin = 35;

  @override
  void dispose() {
    _purchaseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final purchase = parseCurrencyInput(_purchaseController.text) ?? 0;
    final suggested = purchase * (1 + (_margin / 100));
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: FormBuilder(
        key: _formKey,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(widget.productName, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          FormBuilderTextField(
            name: 'quantity',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: widget.quantityLabel),
          ),
          const SizedBox(height: 12),
          FormBuilderCurrencyField(
            name: 'purchase',
            labelText: widget.purchasePriceLabel,
            controller: _purchaseController,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 10),
          InventoryMarginSlider(
            value: _margin,
            label: l10n.inventoryMarginLabel,
            onChanged: (value) => setState(() => _margin = value),
          ),
          const SizedBox(height: 8),
          InventoryPricePreviewCard(
            title: l10n.inventoryPreviewTitle,
            purchaseLabel: widget.purchasePriceLabel,
            suggestedLabel: l10n.productSuggestedPriceTitle,
            purchaseValue: formatCurrency(purchase),
            suggestedValue: formatCurrency(suggested),
          ),
          const SizedBox(height: 10),
          FormBuilderDropdown<String>(
            name: 'unit',
            initialValue: widget.units.isEmpty ? '' : widget.units.first.id,
            decoration: InputDecoration(labelText: l10n.salesUnitLabel),
            items: widget.units.map((e) => DropdownMenuItem(value: e.id, child: Text(e.label))).toList(),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.check_circle_outline),
              label: Text(widget.saveLabel),
            ),
          ),
        ]),
      ),
    );
  }

  void _save() {
    if (!(_formKey.currentState?.saveAndValidate() ?? false)) return;
    final values = _formKey.currentState!.value;
    final quantity = double.tryParse('${values['quantity']}') ?? 0;
    final purchase = parseCurrencyInput('${values['purchase']}') ?? 0;
    if (quantity <= 0 || purchase <= 0) return;
    final unitId = values['unit'] as String? ?? '';
    String unitLabel = '';
    for (final unit in widget.units) {
      if (unit.id == unitId) unitLabel = unit.label;
    }
    widget.onSave(InventoryEntry(
      id: '',
      productId: widget.productId,
      productName: widget.productName,
      quantity: quantity,
      purchasePrice: purchase,
      suggestedSalePrice: purchase * (1 + (_margin / 100)),
      marginPercent: _margin,
      unitId: unitId,
      unitLabel: unitLabel,
      createdAt: DateTime.now(),
    ));
    Navigator.of(context).pop();
  }
}
