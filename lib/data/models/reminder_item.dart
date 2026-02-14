import 'package:hive/hive.dart';

part 'reminder_item.g.dart';

@HiveType(typeId: 4)
class ReminderItem extends HiveObject {
  ReminderItem({
    required this.id,
    required this.title,
    required this.description,
    required this.label,
    required this.enabled,
    required this.hour,
    required this.minute,
    required this.weekdays,
    this.destinationId,
    this.createdAtMs,
    this.notificationBaseId,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String label;

  @HiveField(4)
  final bool enabled;

  @HiveField(5)
  final int hour;

  @HiveField(6)
  final int minute;

  @HiveField(7)
  final List<int> weekdays;

  @HiveField(8)
  final String? destinationId;

  @HiveField(9)
  final int? createdAtMs;

  @HiveField(10)
  final int? notificationBaseId;

  ReminderItem copyWith({
    String? id,
    String? title,
    String? description,
    String? label,
    bool? enabled,
    int? hour,
    int? minute,
    List<int>? weekdays,
    String? destinationId,
    bool clearDestinationId = false,
    int? createdAtMs,
    int? notificationBaseId,
  }) {
    return ReminderItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      label: label ?? this.label,
      enabled: enabled ?? this.enabled,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      weekdays: weekdays ?? this.weekdays,
      destinationId: clearDestinationId
          ? null
          : (destinationId ?? this.destinationId),
      createdAtMs: createdAtMs ?? this.createdAtMs,
      notificationBaseId: notificationBaseId ?? this.notificationBaseId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'label': label,
      'enabled': enabled,
      'hour': hour,
      'minute': minute,
      'weekdays': weekdays,
      if (destinationId != null) 'destinationId': destinationId,
      if (createdAtMs != null) 'createdAtMs': createdAtMs,
      if (notificationBaseId != null) 'notificationBaseId': notificationBaseId,
    };
  }

  factory ReminderItem.fromMap(Map<dynamic, dynamic> map) {
    final rawWeekdays = map['weekdays'];
    final normalizedWeekdays = (rawWeekdays is Iterable)
        ? rawWeekdays
              .whereType<num>()
              .map((value) => value.toInt())
              .where((value) => value >= 1 && value <= 7)
              .toSet()
              .toList()
        : <int>[DateTime.monday];

    normalizedWeekdays.sort();

    return ReminderItem(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      label: map['label'] as String? ?? '',
      enabled: map['enabled'] as bool? ?? true,
      hour: (map['hour'] as num?)?.toInt() ?? 9,
      minute: (map['minute'] as num?)?.toInt() ?? 0,
      weekdays: normalizedWeekdays,
      destinationId: map['destinationId'] as String?,
      createdAtMs: (map['createdAtMs'] as num?)?.toInt(),
      notificationBaseId: (map['notificationBaseId'] as num?)?.toInt(),
    );
  }
}
