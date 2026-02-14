import 'package:flutter/material.dart';

import '../../../core/constants/sales_channels.dart';
import '../../../core/widgets/app_sheet.dart';
import '../../../l10n/app_localizations.dart';

enum SalesHistorySort { latest, highestAmount, highestQuantity }

class ProductFilterOption {
  const ProductFilterOption({
    required this.productId,
    required this.productName,
  });

  final String productId;
  final String productName;
}

class SalesHistoryFilterValues {
  const SalesHistoryFilterValues({
    required this.channel,
    required this.productId,
    required this.sort,
  });

  final String? channel;
  final String? productId;
  final SalesHistorySort sort;
}

Future<SalesHistoryFilterValues?> showSalesHistoryFiltersSheet({
  required BuildContext context,
  required String? initialChannel,
  required String? initialProductId,
  required SalesHistorySort initialSort,
  required List<ProductFilterOption> products,
}) async {
  final l10n = AppLocalizations.of(context);

  var tempChannel = initialChannel;
  var tempProduct = initialProductId;
  var tempSort = initialSort;

  final apply = await showAppSheet<bool>(
    context: context,
    title: l10n.salesHistoryTitle,
    isScrollControlled: true,
    useSafeArea: true,
    contentBuilder: (context) {
      return [
        StatefulBuilder(
          builder: (context, setModalState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.salesChannel,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String?>(
                  key: ValueKey(tempChannel),
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
                  onChanged: (value) => setModalState(() {
                    tempChannel = value;
                  }),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.salesProductName,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String?>(
                  key: ValueKey(tempProduct),
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
                  onChanged: (value) => setModalState(() {
                    tempProduct = value;
                  }),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.salesFiltersSort,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<SalesHistorySort>(
                  key: ValueKey(tempSort),
                  initialValue: tempSort,
                  items: [
                    DropdownMenuItem(
                      value: SalesHistorySort.latest,
                      child: Text(l10n.salesSortLatest),
                    ),
                    DropdownMenuItem(
                      value: SalesHistorySort.highestAmount,
                      child: Text(l10n.salesSortHighestAmount),
                    ),
                    DropdownMenuItem(
                      value: SalesHistorySort.highestQuantity,
                      child: Text(l10n.salesSortHighestQuantity),
                    ),
                  ],
                  onChanged: (value) => setModalState(() {
                    tempSort = value ?? SalesHistorySort.latest;
                  }),
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
                            tempSort = SalesHistorySort.latest;
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
            );
          },
        ),
      ];
    },
  );

  if (apply != true) return null;

  return SalesHistoryFilterValues(
    channel: tempChannel,
    productId: tempProduct,
    sort: tempSort,
  );
}
