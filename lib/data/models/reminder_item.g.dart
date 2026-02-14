// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReminderItemAdapter extends TypeAdapter<ReminderItem> {
  @override
  final int typeId = 4;

  @override
  ReminderItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReminderItem(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      label: fields[3] as String,
      enabled: fields[4] as bool,
      hour: fields[5] as int,
      minute: fields[6] as int,
      weekdays: (fields[7] as List).cast<int>(),
      destinationId: fields[8] as String?,
      createdAtMs: fields[9] as int?,
      notificationBaseId: fields[10] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, ReminderItem obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.label)
      ..writeByte(4)
      ..write(obj.enabled)
      ..writeByte(5)
      ..write(obj.hour)
      ..writeByte(6)
      ..write(obj.minute)
      ..writeByte(7)
      ..write(obj.weekdays)
      ..writeByte(8)
      ..write(obj.destinationId)
      ..writeByte(9)
      ..write(obj.createdAtMs)
      ..writeByte(10)
      ..write(obj.notificationBaseId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
