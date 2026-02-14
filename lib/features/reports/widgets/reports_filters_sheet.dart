import 'package:flutter/material.dart';

import '../../../core/constants/sales_channels.dart';
import '../../../core/widgets/app_sheet.dart';
import '../../../l10n/app_localizations.dart';

class ReportsProductFilterOption {
  const ReportsProductFilterOption({
    required this.productId,
    required this.productName,
  });

  final String productId;
  final String productName;
}

class ReportsAdvancedFilterValues {
  const ReportsAdvancedFilterValues({
    required this.channel,
    required this.productId,
    required this.minAmount,
    required this.maxAmount,
    required this.minQuantity,
  });

  final String? channel;
  final String? productId;
  final double? minAmount;
  final double? maxAmount;
  final int? minQuantity;
}

Future<ReportsAdvancedFilterValues?> showReportsFiltersSheet({
  required BuildContext context,
  required String? initialChannel,
  required String? initialProductId,
  required double? initialMinAmount,
  required double? initialMaxAmount,
  required int? initialMinQuantity,
  required List<ReportsProductFilterOption> products,
}) async {
  final l10n = AppLocalizations.of(context);
  var tempChannel = initialChannel;
  var tempProduct = initialProductId;

  final minAmountController = TextEditingController(
    text: initialMinAmount?.toStringAsFixed(2) ?? '',
  );
  final maxAmountController = TextEditingController(
    text: initialMaxAmount?.toStringAsFixed(2) ?? '',
  );
  final minQtyController = TextEditingController(
    text: initialMinQuantity?.toString() ?? '',
  );

  final apply = await showAppSheet<bool>(
    context: context,
    title: l10n.reportsTitle,
    isScrollControlled: true,
    useSafeArea: true,
    paddingBuilder: (context) => EdgeInsets.fromLTRB(
      16,
      12,
      16,
      16 + MediaQuery.of(context).viewInsets.bottom,
    ),
    contentBuilder: (context) {
      return [
        StatefulBuilder(
          builder: (context, setModalState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.salesChannel,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String?>(
                    key: ValueKey('channel_${tempChannel ?? 'all'}'),
                    initialValue: tempChannel,
                    items: [
                      DropdownMenuItem<String?>(
                        value: null,
                        child: Text(l10n.salesFiltersAll),
                      ),
                      DropdownMenuItem<String?>(
                        value: SalesChannels.retail,
                        child: Text(l10n.salesChannelRetail),
                      ),
                      DropdownMenuItem<String?>(
                        value: SalesChannels.wholesale,
                        child: Text(l10n.salesChannelWholesale),
                      ),
                    ],
                    onChanged: (value) =>
                        setModalState(() => tempChannel = value),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.salesProductName,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String?>(
                    key: ValueKey('product_${tempProduct ?? 'all'}'),
                    initialValue: tempProduct,
                    items: [
                      DropdownMenuItem<String?>(
                        value: null,
                        child: Text(l10n.salesFiltersAll),
                      ),
                      ...products.map(
                        (product) => DropdownMenuItem<String?>(
                          value: product.productId,
                          child: Text(product.productName),
                        ),
                      ),
                    ],
                    onChanged: (value) =>
                        setModalState(() => tempProduct = value),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.reportsFilterAmountRange,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: minAmountController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: InputDecoration(
                            labelText: l10n.reportsFilterMinAmount,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: maxAmountController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: InputDecoration(
                            labelText: l10n.reportsFilterMaxAmount,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: minQtyController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: l10n.reportsFilterMinQuantity,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setModalState(() {
                              tempChannel = null;
                              tempProduct = null;
                              minAmountController.clear();
                              maxAmountController.clear();
                              minQtyController.clear();
                            });
                          },
                          child: Text(l10n.salesFiltersClear),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text(l10n.salesFiltersApply),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ];
    },
  );

  if (apply != true) return null;

  return ReportsAdvancedFilterValues(
    channel: tempChannel,
    productId: tempProduct,
    minAmount: double.tryParse(minAmountController.text.trim()),
    maxAmount: double.tryParse(maxAmountController.text.trim()),
    minQuantity: int.tryParse(minQtyController.text.trim()),
  );
}
