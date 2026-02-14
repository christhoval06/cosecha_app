import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import 'reports_dashboard_config.dart';
import 'reports_dashboard_registry.dart';

Future<ReportsDashboardConfig?> showReportsDashboardCustomizeSheet({
  required BuildContext context,
  required ReportsDashboardConfig current,
  required List<ReportsDashboardWidgetDef> definitions,
}) async {
  var tempOrder = List<String>.from(current.orderedWidgetIds);
  var tempEnabled = List<String>.from(current.enabledWidgetIds);
  final presets = _buildPresets();
  final defaultOrder = definitions.map((d) => d.id).toList();
  String? selectedPresetId;

  return showModalBottomSheet<ReportsDashboardConfig>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) {
      final l10n = AppLocalizations.of(context);
      selectedPresetId = _resolvePresetId(
        presets: presets,
        enabledIds: tempEnabled,
      );
      return StatefulBuilder(
        builder: (context, setModalState) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.reportsCustomizeTitle,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setModalState(() {
                            tempOrder = definitions.map((d) => d.id).toList();
                            tempEnabled = definitions.map((d) => d.id).toList();
                          });
                        },
                        child: Text(l10n.salesFiltersClear),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      l10n.reportsCustomizePresetsTitle,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final preset in presets)
                        ChoiceChip(
                          label: Text(preset.label(l10n)),
                          selected: selectedPresetId == preset.id,
                          onSelected: (_) {
                            setModalState(() {
                              selectedPresetId = preset.id;
                              tempOrder = List<String>.from(defaultOrder);
                              tempEnabled = defaultOrder
                                  .where(preset.enabledIds.contains)
                                  .toList();
                            });
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ReorderableListView.builder(
                      itemCount: tempOrder.length,
                      onReorder: (oldIndex, newIndex) {
                        setModalState(() {
                          selectedPresetId = null;
                          if (newIndex > oldIndex) newIndex--;
                          final moved = tempOrder.removeAt(oldIndex);
                          tempOrder.insert(newIndex, moved);
                        });
                      },
                      itemBuilder: (context, index) {
                        final id = tempOrder[index];
                        final def = definitions.firstWhere((d) => d.id == id);
                        final enabled = tempEnabled.contains(id);
                        return SwitchListTile(
                          key: ValueKey(id),
                          value: enabled,
                          title: Row(
                            children: [
                              Icon(
                                Icons.drag_indicator,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 8),
                              Expanded(child: Text(def.title(l10n))),
                            ],
                          ),
                          onChanged: (value) {
                            setModalState(() {
                              selectedPresetId = null;
                              if (value) {
                                if (!tempEnabled.contains(id)) {
                                  tempEnabled.add(id);
                                }
                              } else {
                                tempEnabled.remove(id);
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        Navigator.of(context).pop(
                          ReportsDashboardConfig(
                            enabledWidgetIds: tempEnabled,
                            orderedWidgetIds: tempOrder,
                          ),
                        );
                      },
                      child: Text(l10n.salesFiltersApply),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

class _ReportsPreset {
  const _ReportsPreset({
    required this.id,
    required this.label,
    required this.enabledIds,
  });

  final String id;
  final String Function(AppLocalizations l10n) label;
  final List<String> enabledIds;
}

List<_ReportsPreset> _buildPresets() {
  return const [
    _ReportsPreset(
      id: 'basic',
      label: _basicPresetLabel,
      enabledIds: [
        ReportsDashboardWidgetIds.exportTools,
        ReportsDashboardWidgetIds.summary,
        ReportsDashboardWidgetIds.totalSalesTrend,
        ReportsDashboardWidgetIds.monthlySales,
      ],
    ),
    _ReportsPreset(
      id: 'commercial',
      label: _commercialPresetLabel,
      enabledIds: [
        ReportsDashboardWidgetIds.exportTools,
        ReportsDashboardWidgetIds.summary,
        ReportsDashboardWidgetIds.periodComparison,
        ReportsDashboardWidgetIds.totalSalesTrend,
        ReportsDashboardWidgetIds.channelMix,
        ReportsDashboardWidgetIds.monthlySales,
        ReportsDashboardWidgetIds.topProducts,
      ],
    ),
    _ReportsPreset(
      id: 'analytical',
      label: _analyticalPresetLabel,
      enabledIds: [
        ReportsDashboardWidgetIds.exportTools,
        ReportsDashboardWidgetIds.summary,
        ReportsDashboardWidgetIds.periodComparison,
        ReportsDashboardWidgetIds.totalSalesTrend,
        ReportsDashboardWidgetIds.channelMix,
        ReportsDashboardWidgetIds.monthlySales,
        ReportsDashboardWidgetIds.dailyHeatmap,
        ReportsDashboardWidgetIds.topProducts,
        ReportsDashboardWidgetIds.bottomProducts,
      ],
    ),
  ];
}

String _basicPresetLabel(AppLocalizations l10n) => l10n.reportsPresetBasic;
String _commercialPresetLabel(AppLocalizations l10n) => l10n.reportsPresetCommercial;
String _analyticalPresetLabel(AppLocalizations l10n) => l10n.reportsPresetAnalytical;

String? _resolvePresetId({
  required List<_ReportsPreset> presets,
  required List<String> enabledIds,
}) {
  final enabledSet = enabledIds.toSet();
  for (final preset in presets) {
    final presetSet = preset.enabledIds.toSet();
    if (enabledSet.length != presetSet.length) continue;
    if (enabledSet.containsAll(presetSet)) return preset.id;
  }
  return null;
}
