// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_price_history.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductPriceHistoryAdapter extends TypeAdapter<ProductPriceHistory> {
  @override
  final int typeId = 2;

  @override
  ProductPriceHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductPriceHistory(
      id: fields[0] as String,
      productId: fields[1] as String,
      price: fields[2] as double,
      recordedAt: fields[3] as DateTime,
      strategyTags: fields[4] == null ? [] : (fields[4] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ProductPriceHistory obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.productId)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.recordedAt)
      ..writeByte(4)
      ..write(obj.strategyTags);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductPriceHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
