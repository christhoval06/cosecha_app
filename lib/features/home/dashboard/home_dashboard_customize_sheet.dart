import 'package:flutter/material.dart';

import '../../../core/widgets/app_sheet.dart';
import '../../../l10n/app_localizations.dart';
import 'home_dashboard_config.dart';
import 'home_dashboard_registry.dart';

Future<HomeDashboardConfig?> showHomeDashboardCustomizeSheet({
  required BuildContext context,
  required HomeDashboardConfig current,
  required List<HomeDashboardWidgetDef> definitions,
}) async {
  var tempOrder = List<String>.from(current.orderedWidgetIds);
  var tempEnabled = List<String>.from(current.enabledWidgetIds);
  final presets = _buildPresets();
  final defaultOrder = definitions.map((d) => d.id).toList();
  String? selectedPresetId;

  return showModalBottomSheet<HomeDashboardConfig>(
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
          return AppSheetLayout(
            title: l10n.homeCustomizeTitle,
            mainAxisSize: MainAxisSize.max,
            trailing: TextButton(
              onPressed: () {
                setModalState(() {
                  tempOrder = definitions.map((d) => d.id).toList();
                  tempEnabled = definitions.map((d) => d.id).toList();
                });
              },
              child: Text(l10n.salesFiltersClear),
            ),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  l10n.homeCustomizePresetsTitle,
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
                      HomeDashboardConfig(
                        enabledWidgetIds: tempEnabled,
                        orderedWidgetIds: tempOrder,
                      ),
                    );
                  },
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

class _HomePreset {
  const _HomePreset({
    required this.id,
    required this.label,
    required this.enabledIds,
  });

  final String id;
  final String Function(AppLocalizations l10n) label;
  final List<String> enabledIds;
}

List<_HomePreset> _buildPresets() {
  return const [
    _HomePreset(
      id: 'basic',
      label: _basicPresetLabel,
      enabledIds: [
        HomeDashboardWidgetIds.performance,
        HomeDashboardWidgetIds.quickActions,
        HomeDashboardWidgetIds.quickSale,
        HomeDashboardWidgetIds.latestProducts,
        HomeDashboardWidgetIds.recentSales,
      ],
    ),
    _HomePreset(
      id: 'commercial',
      label: _commercialPresetLabel,
      enabledIds: [
        HomeDashboardWidgetIds.performance,
        HomeDashboardWidgetIds.quickActions,
        HomeDashboardWidgetIds.salesGoal,
        HomeDashboardWidgetIds.channelMix,
        HomeDashboardWidgetIds.productsAtRisk,
        HomeDashboardWidgetIds.quickSale,
        HomeDashboardWidgetIds.latestProducts,
        HomeDashboardWidgetIds.recentSales,
      ],
    ),
    _HomePreset(
      id: 'analytical',
      label: _analyticalPresetLabel,
      enabledIds: [
        HomeDashboardWidgetIds.performance,
        HomeDashboardWidgetIds.salesGoal,
        HomeDashboardWidgetIds.channelMix,
        HomeDashboardWidgetIds.avgTicketTrend,
        HomeDashboardWidgetIds.weeklyActivity,
        HomeDashboardWidgetIds.weeklyInsights,
        HomeDashboardWidgetIds.recentSales,
      ],
    ),
  ];
}

String _basicPresetLabel(AppLocalizations l10n) => l10n.homePresetBasic;
String _commercialPresetLabel(AppLocalizations l10n) =>
    l10n.homePresetCommercial;
String _analyticalPresetLabel(AppLocalizations l10n) =>
    l10n.homePresetAnalytical;

String? _resolvePresetId({
  required List<_HomePreset> presets,
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
