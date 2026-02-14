import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../../core/widgets/avatar_image_picker.dart';
import '../../core/widgets/form_builder_currency_field.dart';
import '../../core/utils/file.dart';
import '../../data/hive/boxes.dart';
import '../../data/models/product.dart';
import '../../data/models/product_price_history.dart';
import '../../data/models/sale_transaction.dart';
import '../../data/repositories/product_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../core/utils/formatters.dart';
import 'product_pricing_insights.dart';
import 'widgets/labelled_field.dart';
import 'widgets/product_premium_insights_section.dart';
import 'widgets/product_price_suggestion_card.dart';
import 'widgets/product_sales_performance_section.dart';
import 'widgets/product_strategy_tags_picker.dart';

class ProductEditScreen extends StatefulWidget {
  const ProductEditScreen({super.key, this.product});

  final Product? product;

  @override
  State<ProductEditScreen> createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends State<ProductEditScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _repository = ProductRepository();
  late final TextEditingController _priceController;
  late final int _currencyDecimalDigits;
  late final NumberFormat _priceNumberFormatter;

  String? _imagePath;
  String _range = '1M';
  bool _saving = false;
  double? _priceDraft;

  bool get _isEdit => widget.product != null;

  @override
  void initState() {
    super.initState();
    _imagePath = widget.product?.imageUrl;
    _currencyDecimalDigits = currencyDecimalDigitsForCurrentBusiness();
    _priceNumberFormatter = NumberFormat.decimalPatternDigits(
      locale: 'en_US',
      decimalDigits: _currencyDecimalDigits,
    );
    _priceController = TextEditingController(
      text: widget.product == null
          ? ''
          : _priceNumberFormatter.format(widget.product!.currentPrice),
    );
    _priceDraft = widget.product?.currentPrice;
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
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
    final strategyOptions = [
      l10n.productStrategyPromo,
      l10n.productStrategySeason,
      l10n.productStrategyCost,
      l10n.productStrategyCompetition,
    ];
    final now = DateTime.now();
    final List<ProductPriceHistory> history = _isEdit
        ? _repository.getHistory(widget.product!.id)
        : <ProductPriceHistory>[];
    final from = _rangeStart(now);
    final to = now;
    final filtered = history
        .where(
          (item) =>
              !item.recordedAt.isBefore(from) && !item.recordedAt.isAfter(to),
        )
        .toList();
    final values = filtered.map((item) => item.price).toList().cast<double>();
    final totalLabel = values.isNotEmpty
        ? formatCurrency(values.last)
        : formatCurrency(widget.product?.currentPrice ?? 0);
    // Use the latest two price points: previous vs current.
    final changePercent = values.length >= 2
        ? _changePercent(
            previous: values[values.length - 2],
            current: values.last,
          )
        : null;
    final currentPrice = _priceDraft ?? widget.product?.currentPrice ?? 0.0;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          if (_isEdit)
            IconButton(
              onPressed: _saving ? null : _duplicateProduct,
              icon: const Icon(Icons.copy_outlined),
            ),
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
                child: FormBuilderCurrencyField(
                  name: 'price',
                  labelText: l10n.productPriceLabel,
                  controller: _priceController,
                  hintText: l10n.productPriceHint,
                  onChanged: (value) {
                    setState(() {
                      _priceDraft = _parsePriceInput(value);
                    });
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.productPriceRequired;
                    }
                    final parsed = _parsePriceInput(value);
                    if (parsed == null || parsed <= 0) {
                      return l10n.productPriceInvalid;
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.productPricePreview(
                  formatCurrency(currentPrice > 0 ? currentPrice : 0),
                ),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 16),
              FormBuilderField<List<String>>(
                name: 'strategy_tags',
                initialValue: const <String>[],
                builder: (field) {
                  return ProductStrategyTagsPicker(
                    title: l10n.productStrategyTitle,
                    options: strategyOptions,
                    selected: (field.value ?? const <String>[]).toSet(),
                    onChanged: (next) {
                      field.didChange(next.toList(growable: false));
                    },
                  );
                },
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
              if (_isEdit)
                Column(
                  children: [
                    const SizedBox(height: 16),
                    ProductSalesPerformanceSection(
                      product: widget.product!,
                      range: _range,
                      onRangeChanged: (value) => setState(() => _range = value),
                      from: from,
                      to: to,
                    ),
                    ProductPremiumInsightsSection(
                      l10n: l10n,
                      product: widget.product!,
                      currentPrice: currentPrice,
                      suggestedPriceCard: _buildSuggestedPriceCard(l10n),
                      totalLabel: totalLabel,
                      changePercent: changePercent,
                      values: values,
                      from: from,
                      to: to,
                      history: history,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestedPriceCard(AppLocalizations l10n) {
    return ValueListenableBuilder<Box<SaleTransaction>>(
      valueListenable: Hive.box<SaleTransaction>(
        HiveBoxes.transactions,
      ).listenable(),
      builder: (context, box, _) {
        final suggested = ProductPricingInsights.suggestedPrice(
          productId: widget.product!.id,
          productName: widget.product!.name,
          currentPrice: widget.product!.currentPrice,
          sales: box.values,
        );
        if (suggested == null) return const SizedBox.shrink();
        return ProductPriceSuggestionCard(
          title: l10n.productSuggestedPriceTitle,
          subtitle: l10n.productSuggestedPriceSubtitle,
          currentPrice: widget.product!.currentPrice,
          suggestedPrice: suggested,
          applyLabel: l10n.productSuggestedPriceApply,
          onApply: () {
            _formKey.currentState?.fields['price']?.didChange(
              _priceNumberFormatter.format(suggested),
            );
            _priceController.text = _priceNumberFormatter.format(suggested);
            setState(() => _priceDraft = suggested);
          },
        );
      },
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

  double? _changePercent({required double previous, required double current}) {
    if (previous <= 0) return null;
    return ((current - previous) / previous) * 100;
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
    final price = _parsePriceInput(priceRaw) ?? 0;
    final strategyTags = (values['strategy_tags'] as List<dynamic>? ?? const [])
        .map((e) => e.toString())
        .toList(growable: false);
    final image = values['image'] as String?;
    final productId = widget.product?.id.isNotEmpty == true
        ? widget.product!.id
        : DateTime.now().millisecondsSinceEpoch.toString();
    String resolvedImagePath = '';
    if (image != null && image.isNotEmpty) {
      final isSamePathAsCurrent = _isEdit && image == widget.product?.imageUrl;
      if (isSamePathAsCurrent) {
        resolvedImagePath = image;
      } else {
        final savedImagePath = await saveLocallyFromPath(
          image,
          fileNamePrefix: 'product_$productId',
        );
        resolvedImagePath = savedImagePath ?? (widget.product?.imageUrl ?? '');
      }
    }

    final product = Product(
      id: productId,
      name: name,
      imageUrl: resolvedImagePath,
      currentPrice: price,
    );

    if (_isEdit && !(await _allowExtremeChange(price, strategyTags))) {
      setState(() => _saving = false);
      return;
    }

    try {
      await _repository.save(product, priceChangeTags: strategyTags);
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

  Future<void> _duplicateProduct() async {
    if (!_isEdit || _saving) return;
    final l10n = AppLocalizations.of(context);
    final source = widget.product!;
    final duplicated = Product(
      id: '',
      name: '${source.name} (${l10n.productDuplicateSuffix})',
      imageUrl: source.imageUrl,
      currentPrice: source.currentPrice,
    );
    try {
      await _repository.save(duplicated);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.productDuplicateSuccess)));
      Navigator.of(context).pop();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${l10n.productSaveError}: $error')),
      );
    }
  }

  Future<bool> _allowExtremeChange(
    double nextPrice,
    List<String> strategyTags,
  ) async {
    final previous = widget.product?.currentPrice;
    if (previous == null || previous <= 0) return true;
    final deltaPercent = ((nextPrice - previous) / previous) * 100;
    if (deltaPercent.abs() < 30) return true;
    final l10n = AppLocalizations.of(context);
    final strategy = strategyTags.isEmpty
        ? l10n.salesFiltersAll
        : strategyTags.join(', ');
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.productExtremeChangeTitle),
          content: Text(
            l10n.productExtremeChangeBody(
              '${deltaPercent >= 0 ? '+' : ''}${deltaPercent.toStringAsFixed(1)}%',
              strategy,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.confirm),
            ),
          ],
        );
      },
    );
    return confirmed == true;
  }

  double? _parsePriceInput(String? raw) {
    return parseCurrencyInput(raw, decimalDigits: _currencyDecimalDigits);
  }
}
