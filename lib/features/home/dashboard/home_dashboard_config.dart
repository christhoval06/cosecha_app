import 'package:shared_preferences/shared_preferences.dart';

class HomeDashboardConfig {
  const HomeDashboardConfig({
    required this.enabledWidgetIds,
    required this.orderedWidgetIds,
  });

  final List<String> enabledWidgetIds;
  final List<String> orderedWidgetIds;
}

class HomeDashboardConfigStore {
  static const _enabledKey = 'home_dashboard_enabled_widgets';
  static const _orderKey = 'home_dashboard_order_widgets';

  Future<HomeDashboardConfig> load(
    List<String> defaultOrderWidgetIds, {
    List<String>? defaultEnabledWidgetIds,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final savedEnabled = prefs.getStringList(_enabledKey);
    final savedOrder = prefs.getStringList(_orderKey);

    final enabledDefaults = defaultEnabledWidgetIds ?? defaultOrderWidgetIds;
    final ordered = _sanitizeOrder(
      savedOrder ?? defaultOrderWidgetIds,
      defaultOrderWidgetIds,
    );
    final enabled = _sanitizeEnabled(savedEnabled ?? enabledDefaults, ordered);

    return HomeDashboardConfig(
      enabledWidgetIds: enabled,
      orderedWidgetIds: ordered,
    );
  }

  Future<void> save(HomeDashboardConfig config) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_enabledKey, config.enabledWidgetIds);
    await prefs.setStringList(_orderKey, config.orderedWidgetIds);
  }

  List<String> _sanitizeOrder(List<String> source, List<String> defaults) {
    final known = defaults.toSet();
    final unique = <String>[];
    for (final id in source) {
      if (!known.contains(id)) continue;
      if (unique.contains(id)) continue;
      unique.add(id);
    }
    for (final id in defaults) {
      if (!unique.contains(id)) unique.add(id);
    }
    return unique;
  }

  List<String> _sanitizeEnabled(List<String> source, List<String> ordered) {
    final known = ordered.toSet();
    final unique = <String>[];
    for (final id in source) {
      if (!known.contains(id)) continue;
      if (unique.contains(id)) continue;
      unique.add(id);
    }
    return unique;
  }
}
