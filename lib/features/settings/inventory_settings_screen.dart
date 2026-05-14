import 'package:flutter/material.dart';

import '../../core/services/inventory_settings_service.dart';
import '../../l10n/app_localizations.dart';
import 'widgets/inventory_toggle_tile.dart';
import 'widgets/sales_units_card.dart';

class InventorySettingsScreen extends StatefulWidget {
  const InventorySettingsScreen({super.key});

  @override
  State<InventorySettingsScreen> createState() => _InventorySettingsScreenState();
}

class _InventorySettingsScreenState extends State<InventorySettingsScreen> {
  bool _loading = true;
  bool _enabled = false;
  List<InventoryUnit> _units = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final enabled = await InventorySettingsService.isEnabled();
    final units = await InventorySettingsService.getUnits();
    if (!mounted) return;
    setState(() {
      _enabled = enabled;
      _units = units;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.inventorySettingsTitle)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                InventoryToggleTile(
                  title: l10n.inventoryFeatureTitle,
                  subtitle: l10n.inventoryFeatureSubtitle,
                  value: _enabled,
                  onChanged: (value) async {
                    await InventorySettingsService.setEnabled(value);
                    if (!mounted) return;
                    setState(() => _enabled = value);
                  },
                ),
                const SizedBox(height: 16),
                SalesUnitsCard(
                  title: l10n.inventoryUnitsTitle,
                  hint: l10n.inventoryUnitsHint,
                  units: _units,
                  onAdd: _addUnit,
                  onDelete: _deleteUnit,
                ),
              ],
            ),
    );
  }

  Future<void> _addUnit(String value) async {
    final label = value.trim();
    if (label.isEmpty) return;
    final id = label.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_');
    final exists = _units.any((unit) => unit.id == id || unit.label == label);
    if (exists) return;
    final next = [..._units, InventoryUnit(id: id, label: label)];
    await InventorySettingsService.setUnits(next);
    if (!mounted) return;
    setState(() => _units = next);
  }

  Future<void> _deleteUnit(InventoryUnit value) async {
    final next = _units.where((unit) => unit.id != value.id).toList();
    await InventorySettingsService.setUnits(next);
    if (!mounted) return;
    setState(() => _units = next);
  }
}
