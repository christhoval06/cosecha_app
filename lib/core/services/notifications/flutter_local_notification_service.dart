import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'notification_service.dart';

class FlutterLocalNotificationService implements NotificationService {
  FlutterLocalNotificationService._();

  static final FlutterLocalNotificationService instance =
      FlutterLocalNotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  @override
  Future<void> initialize({required NotificationTapCallback onTap}) async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings('app_icon');
    const iosSettings = DarwinInitializationSettings(
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      defaultPresentSound: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (response) async {
        await onTap(response.payload);
      },
    );

    final launchDetails = await _plugin.getNotificationAppLaunchDetails();
    final launchedFromNotification =
        launchDetails?.didNotificationLaunchApp ?? false;
    if (launchedFromNotification) {
      await onTap(launchDetails?.notificationResponse?.payload);
    }

    _initialized = true;
  }

  @override
  Future<bool> requestPermissions() async {
    final iosPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    final macPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin
        >();
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    final iosGranted = await iosPlugin?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
    final macGranted = await macPlugin?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
    final androidGranted = await androidPlugin
        ?.requestNotificationsPermission();

    return (iosGranted ?? true) &&
        (macGranted ?? true) &&
        (androidGranted ?? true);
  }

  @override
  Future<void> show(NotificationRequest request) async {
    await _plugin.show(
      id: request.id,
      title: request.title,
      body: request.body,
      notificationDetails: _detailsFor(request),
      payload: request.payload,
    );
  }

  @override
  Future<void> showPeriodic(
    NotificationRequest request, {
    required AppNotificationRepeat repeat,
  }) async {
    await _plugin.periodicallyShow(
      id: request.id,
      title: request.title,
      body: request.body,
      repeatInterval: _repeatIntervalFor(repeat),
      notificationDetails: _detailsFor(request),
      payload: request.payload,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  @override
  Future<void> cancel(int id) {
    return _plugin.cancel(id: id);
  }

  @override
  Future<void> cancelAll() {
    return _plugin.cancelAll();
  }

  NotificationDetails _detailsFor(NotificationRequest request) {
    final channel = request.channel;
    final importance = request.highPriority
        ? Importance.max
        : Importance.defaultImportance;
    final priority = request.highPriority
        ? Priority.high
        : Priority.defaultPriority;
    return NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description,
        icon: 'app_icon',
        importance: importance,
        priority: priority,
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  RepeatInterval _repeatIntervalFor(AppNotificationRepeat repeat) {
    switch (repeat) {
      case AppNotificationRepeat.hourly:
        return RepeatInterval.hourly;
      case AppNotificationRepeat.daily:
        return RepeatInterval.daily;
      case AppNotificationRepeat.weekly:
        return RepeatInterval.weekly;
    }
  }
}
