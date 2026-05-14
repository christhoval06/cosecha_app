// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InventoryEntryAdapter extends TypeAdapter<InventoryEntry> {
  @override
  final int typeId = 5;

  @override
  InventoryEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InventoryEntry(
      id: fields[0] as String,
      productId: fields[1] as String,
      productName: fields[2] as String,
      quantity: fields[3] as double,
      purchasePrice: fields[4] as double,
      suggestedSalePrice: fields[5] as double,
      marginPercent: fields[6] as double,
      unitId: fields[7] as String,
      unitLabel: fields[8] as String,
      createdAt: fields[9] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, InventoryEntry obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.productId)
      ..writeByte(2)
      ..write(obj.productName)
      ..writeByte(3)
      ..write(obj.quantity)
      ..writeByte(4)
      ..write(obj.purchasePrice)
      ..writeByte(5)
      ..write(obj.suggestedSalePrice)
      ..writeByte(6)
      ..write(obj.marginPercent)
      ..writeByte(7)
      ..write(obj.unitId)
      ..writeByte(8)
      ..write(obj.unitLabel)
      ..writeByte(9)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InventoryEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
