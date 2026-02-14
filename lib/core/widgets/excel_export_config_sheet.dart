import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../services/excel_export_service.dart';
import 'app_sheet.dart';

Future<ExcelExportConfig?> showExcelExportConfigSheet({
  required BuildContext context,
  required ExcelExportConfig current,
}) async {
  var temp = current.sanitize();

  return showModalBottomSheet<ExcelExportConfig>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) {
      final l10n = AppLocalizations.of(context);
      return StatefulBuilder(
        builder: (context, setModalState) {
          return AppSheetLayout(
            title: l10n.excelExportConfigTitle,
            mainAxisSize: MainAxisSize.max,
            trailing: TextButton(
              onPressed: () {
                setModalState(() {
                  temp = ExcelExportConfig.all();
                });
              },
              child: Text(l10n.salesFiltersClear),
            ),
            children: [
              Expanded(
                child: ListView(
                  children: [
                    for (final model in ExcelExportService.models)
                      _ModelSection(
                        model: model,
                        config: temp,
                        l10n: l10n,
                        onToggleModel: (enabled) {
                          setModalState(() {
                            final enabledModels = Set<String>.from(
                              temp.enabledModels,
                            );
                            if (enabled) {
                              enabledModels.add(model);
                            } else {
                              enabledModels.remove(model);
                            }
                            temp = temp
                                .copyWith(enabledModels: enabledModels)
                                .sanitize();
                          });
                        },
                        onToggleField: (field, enabled) {
                          setModalState(() {
                            final fields = {
                              for (final entry
                                  in temp.enabledFieldsByModel.entries)
                                entry.key: Set<String>.from(entry.value),
                            };
                            final modelFields = fields[model] ?? <String>{};
                            if (enabled) {
                              modelFields.add(field);
                            } else {
                              modelFields.remove(field);
                            }
                            fields[model] = modelFields;
                            temp = temp
                                .copyWith(enabledFieldsByModel: fields)
                                .sanitize();
                          });
                        },
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(temp.sanitize()),
                  child: Text(l10n.salesFiltersApply),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

class _ModelSection extends StatelessWidget {
  const _ModelSection({
    required this.model,
    required this.config,
    required this.l10n,
    required this.onToggleModel,
    required this.onToggleField,
  });

  final String model;
  final ExcelExportConfig config;
  final AppLocalizations l10n;
  final ValueChanged<bool> onToggleModel;
  final void Function(String field, bool enabled) onToggleField;

  @override
  Widget build(BuildContext context) {
    final enabled = config.enabledModels.contains(model);
    final availableFields =
        ExcelExportService.modelFields[model] ?? const <String>[];
    final selectedFields = config.enabledFieldsByModel[model] ?? <String>{};
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              value: enabled,
              onChanged: onToggleModel,
              contentPadding: EdgeInsets.zero,
              title: Text(_modelLabel(l10n, model)),
            ),
            IgnorePointer(
              ignoring: !enabled,
              child: Opacity(
                opacity: enabled ? 1 : 0.5,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final field in availableFields)
                      FilterChip(
                        label: Text(_fieldLabel(l10n, model, field)),
                        selected: selectedFields.contains(field),
                        onSelected: (value) => onToggleField(field, value),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

String _modelLabel(AppLocalizations l10n, String model) {
  switch (model) {
    case ExcelExportService.modelProducts:
      return l10n.excelExportModelProducts;
    case ExcelExportService.modelSales:
      return l10n.excelExportModelSales;
    case ExcelExportService.modelPriceHistory:
      return l10n.excelExportModelPriceHistory;
    default:
      return model;
  }
}

String _fieldLabel(AppLocalizations l10n, String model, String field) {
  switch (model) {
    case ExcelExportService.modelProducts:
      switch (field) {
        case 'id':
          return l10n.excelExportFieldId;
        case 'name':
          return l10n.excelExportFieldName;
        case 'imageUrl':
          return l10n.excelExportFieldImageUrl;
        case 'currentPrice':
          return l10n.excelExportFieldCurrentPrice;
      }
    case ExcelExportService.modelSales:
      switch (field) {
        case 'id':
          return l10n.excelExportFieldId;
        case 'productId':
          return l10n.excelExportFieldProductId;
        case 'productName':
          return l10n.excelExportFieldProductName;
        case 'amount':
          return l10n.excelExportFieldAmount;
        case 'quantity':
          return l10n.excelExportFieldQuantity;
        case 'channel':
          return l10n.excelExportFieldChannel;
        case 'createdAt':
          return l10n.excelExportFieldCreatedAt;
      }
    case ExcelExportService.modelPriceHistory:
      switch (field) {
        case 'id':
          return l10n.excelExportFieldId;
        case 'productId':
          return l10n.excelExportFieldProductId;
        case 'price':
          return l10n.excelExportFieldPrice;
        case 'recordedAt':
          return l10n.excelExportFieldRecordedAt;
        case 'strategyTags':
          return l10n.excelExportFieldStrategyTags;
      }
  }
  return field;
}
