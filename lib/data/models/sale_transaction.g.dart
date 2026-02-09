// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_transaction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SaleTransactionAdapter extends TypeAdapter<SaleTransaction> {
  @override
  final int typeId = 3;

  @override
  SaleTransaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SaleTransaction(
      id: fields[0] as String,
      productName: fields[1] as String,
      productId: fields[6] == null ? '' : fields[6] as String,
      amount: fields[2] as double,
      quantity: fields[3] as int,
      channel: fields[4] as String,
      createdAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, SaleTransaction obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.productName)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.quantity)
      ..writeByte(4)
      ..write(obj.channel)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.productId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SaleTransactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
