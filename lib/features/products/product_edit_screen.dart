import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../core/widgets/avatar_image_picker.dart';
import '../../core/utils/file.dart';
import '../../core/constants/app_routes.dart';
import '../../data/models/product.dart';
import '../../data/repositories/product_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../core/utils/formatters.dart';
import 'widgets/labelled_field.dart';
import 'widgets/price_performance_card.dart';
import 'widgets/segment_tabs.dart';

class ProductEditScreen extends StatefulWidget {
  const ProductEditScreen({super.key, this.product});

  final Product? product;

  @override
  State<ProductEditScreen> createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends State<ProductEditScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _repository = ProductRepository();

  String? _imagePath;
  String _range = '1M';
  bool _saving = false;

  bool get _isEdit => widget.product != null;

  @override
  void initState() {
    super.initState();
    _imagePath = widget.product?.imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final title = _isEdit ? l10n.productEditTitle : l10n.productAddTitle;
    final actionText = _isEdit
        ? l10n.productActionSave
        : l10n.productActionCreate;
    final priceButtonText = _isEdit
        ? l10n.productUpdatePrice
        : l10n.productAddButton;
    final now = DateTime.now();
    final history = _isEdit ? _repository.getHistory(widget.product!.id) : [];
    final from = _rangeStart(now);
    final to = now;
    final filtered = history
        .where(
          (item) => !item.recordedAt.isBefore(from) &&
              !item.recordedAt.isAfter(to),
        )
        .toList();
    final values = filtered.map((item) => item.price).toList().cast<double>();
    final totalLabel = values.isNotEmpty
        ? formatCurrency(values.last)
        : formatCurrency(widget.product?.currentPrice ?? 0);
    final changePercent = values.length >= 2 && values.first > 0
        ? ((values.last - values.first) / values.first) * 100
        : null;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          TextButton(
            onPressed: _saving ? null : _saveProduct,
            child: Text(
              actionText,
              style: TextStyle(color: colorScheme.primary),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: FormBuilder(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              FormBuilderField<String>(
                name: 'image',
                initialValue: _imagePath,
                builder: (field) {
                  return LabelledField(
                    label: l10n.productImageLabel,
                    child: Center(
                      child: AvatarImagePicker(
                        value: field.value,
                        onChanged: (value) {
                          field.didChange(value);
                          setState(() => _imagePath = value);
                        },
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              LabelledField(
                label: l10n.productNameLabel,
                child: FormBuilderTextField(
                  name: 'name',
                  initialValue: widget.product?.name,
                  decoration: InputDecoration(hintText: l10n.productNameHint),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.productNameRequired;
                    }
                    if (value.trim().length < 2) {
                      return l10n.productNameMin(2);
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              LabelledField(
                label: l10n.productDescriptionLabel,
                child: FormBuilderTextField(
                  name: 'description',
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: l10n.productDescriptionHint,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              LabelledField(
                label: l10n.productPriceLabel,
                child: FormBuilderTextField(
                  name: 'price',
                  initialValue: widget.product?.currentPrice.toString(),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixText: '\$ ',
                    hintText: l10n.productPriceHint,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.productPriceRequired;
                    }
                    final parsed = double.tryParse(value.replaceAll(',', '.'));
                    if (parsed == null || parsed <= 0) {
                      return l10n.productPriceInvalid;
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _saving ? null : _saveProduct,
                  icon: const Icon(Icons.add_chart),
                  label: _saving
                      ? Text(l10n.productSaving)
                      : Text(priceButtonText),
                ),
              ),
              if (_isEdit) ...[
                const SizedBox(height: 24),
                PricePerformanceCard(
                  title: l10n.productPricePerformanceTitle,
                  totalLabel: totalLabel,
                  changePercent: changePercent,
                  values: values,
                  from: from,
                  to: to,
                  showLabels: false,
                ),
                const SizedBox(height: 16),
                SegmentTabs(
                  value: _range,
                  onChanged: (value) => setState(() => _range = value),
                  options: const ['1M', '6M', '1Y'],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  DateTime _rangeStart(DateTime now) {
    switch (_range) {
      case '6M':
        return now.subtract(const Duration(days: 180));
      case '1Y':
        return now.subtract(const Duration(days: 365));
      case '1M':
      default:
        return now.subtract(const Duration(days: 30));
    }
  }

  Future<void> _saveProduct() async {
    if (_saving) return;
    final formState = _formKey.currentState;
    if (formState == null) return;

    final isValid = formState.saveAndValidate();
    if (!isValid) return;

    setState(() => _saving = true);

    final values = formState.value;
    final name = (values['name'] as String?)?.trim() ?? '';
    final priceRaw = (values['price'] as String?)?.trim() ?? '';
    final price = double.tryParse(priceRaw.replaceAll(',', '.')) ?? 0;
    final image = values['image'] as String?;
    final savedImagePath = image == null
        ? null
        : await saveLocallyFromPath(image);

    final product = Product(
      id: widget.product?.id ?? '',
      name: name,
      imageUrl: savedImagePath ?? '',
      currentPrice: price,
    );

    try {
      await _repository.save(product);
      if (!mounted) return;
      setState(() => _saving = false);
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;

      final l10n = AppLocalizations.of(context);

      setState(() => _saving = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${l10n.productSaveError}: $e')));
    }
  }
}
