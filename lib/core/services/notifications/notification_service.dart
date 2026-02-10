typedef NotificationTapCallback = Future<void> Function(String? payload);

enum AppNotificationRepeat { hourly, daily, weekly }

class NotificationChannelConfig {
  const NotificationChannelConfig({
    required this.id,
    required this.name,
    required this.description,
  });

  final String id;
  final String name;
  final String description;
}

class NotificationRequest {
  const NotificationRequest({
    required this.id,
    required this.title,
    required this.body,
    required this.channel,
    this.payload,
    this.highPriority = false,
  });

  final int id;
  final String title;
  final String body;
  final NotificationChannelConfig channel;
  final String? payload;
  final bool highPriority;
}

abstract class NotificationService {
  Future<void> initialize({required NotificationTapCallback onTap});

  Future<bool> requestPermissions();

  Future<void> show(NotificationRequest request);

  Future<void> showPeriodic(
    NotificationRequest request, {
    required AppNotificationRepeat repeat,
  });

  Future<void> cancel(int id);

  Future<void> cancelAll();
}
