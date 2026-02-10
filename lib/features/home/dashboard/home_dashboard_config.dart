import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_prefs.dart';

class HomeDashboardConfig {
  const HomeDashboardConfig({
    required this.enabledWidgetIds,
    required this.orderedWidgetIds,
  });

  final List<String> enabledWidgetIds;
  final List<String> orderedWidgetIds;
}

class HomeDashboardConfigStore {
  Future<HomeDashboardConfig> load(
    List<String> defaultOrderWidgetIds, {
    List<String>? defaultEnabledWidgetIds,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final savedEnabled = prefs.getStringList(AppPrefs.homeDashboardEnabledWidgets);
    final savedOrder = prefs.getStringList(AppPrefs.homeDashboardOrderWidgets);

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
    await prefs.setStringList(
      AppPrefs.homeDashboardEnabledWidgets,
      config.enabledWidgetIds,
    );
    await prefs.setStringList(
      AppPrefs.homeDashboardOrderWidgets,
      config.orderedWidgetIds,
    );
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
