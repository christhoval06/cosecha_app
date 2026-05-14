import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_prefs.dart';

class InventoryUnit {
  const InventoryUnit({required this.id, required this.label});

  final String id;
  final String label;
}

class InventorySettingsService {
  InventorySettingsService._();

  static const List<InventoryUnit> defaultUnits = [
    InventoryUnit(id: 'units', label: 'Unidades'),
    InventoryUnit(id: 'kg', label: 'Kilos'),
    InventoryUnit(id: 'lb', label: 'Libras'),
    InventoryUnit(id: 'l', label: 'Litros'),
  ];

  static Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppPrefs.inventoryEnabled) ?? false;
  }

  static Future<void> setEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppPrefs.inventoryEnabled, enabled);
  }

  static Future<List<InventoryUnit>> getUnits() async {
    final prefs = await SharedPreferences.getInstance();
    final rows = prefs.getStringList(AppPrefs.inventoryUnits);
    if (rows == null || rows.isEmpty) return defaultUnits;
    return rows.map(_decodeUnit).whereType<InventoryUnit>().toList();
  }

  static Future<void> setUnits(List<InventoryUnit> units) async {
    final prefs = await SharedPreferences.getInstance();
    final rows = units.map(_encodeUnit).toList(growable: false);
    await prefs.setStringList(AppPrefs.inventoryUnits, rows);
  }

  static String _encodeUnit(InventoryUnit unit) {
    return jsonEncode({'id': unit.id, 'label': unit.label});
  }

  static InventoryUnit? _decodeUnit(String row) {
    try {
      final map = jsonDecode(row) as Map<String, dynamic>;
      final id = (map['id'] as String? ?? '').trim();
      final label = (map['label'] as String? ?? '').trim();
      if (id.isEmpty || label.isEmpty) return null;
      return InventoryUnit(id: id, label: label);
    } catch (_) {
      return null;
    }
  }
}
