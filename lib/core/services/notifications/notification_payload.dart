import 'dart:convert';

class NotificationPayload {
  const NotificationPayload({required this.type, this.route, this.arguments});

  final String type;
  final String? route;
  final Map<String, dynamic>? arguments;

  String encode() {
    return jsonEncode({
      'type': type,
      if (route != null) 'route': route,
      if (arguments != null) 'arguments': arguments,
    });
  }

  static NotificationPayload? tryDecode(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      final map = jsonDecode(raw);
      if (map is! Map<String, dynamic>) return null;
      return NotificationPayload(
        type: map['type'] as String? ?? 'unknown',
        route: map['route'] as String?,
        arguments: map['arguments'] as Map<String, dynamic>?,
      );
    } catch (_) {
      return null;
    }
  }
}
