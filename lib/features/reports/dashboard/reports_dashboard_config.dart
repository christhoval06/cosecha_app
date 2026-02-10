import 'package:shared_preferences/shared_preferences.dart';

class ReportsDashboardConfig {
  const ReportsDashboardConfig({
    required this.enabledWidgetIds,
    required this.orderedWidgetIds,
  });

  final List<String> enabledWidgetIds;
  final List<String> orderedWidgetIds;

  ReportsDashboardConfig copyWith({
    List<String>? enabledWidgetIds,
    List<String>? orderedWidgetIds,
  }) {
    return ReportsDashboardConfig(
      enabledWidgetIds: enabledWidgetIds ?? this.enabledWidgetIds,
      orderedWidgetIds: orderedWidgetIds ?? this.orderedWidgetIds,
    );
  }
}

class ReportsDashboardConfigStore {
  static const _enabledKey = 'reports_dashboard_enabled_widgets';
  static const _orderKey = 'reports_dashboard_order_widgets';

  Future<ReportsDashboardConfig> load(
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

    return ReportsDashboardConfig(
      enabledWidgetIds: enabled,
      orderedWidgetIds: ordered,
    );
  }

  Future<void> save(ReportsDashboardConfig config) async {
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
