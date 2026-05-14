// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductAdapter extends TypeAdapter<Product> {
  @override
  final int typeId = 1;

  @override
  Product read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Product(
      id: fields[0] as String,
      name: fields[1] as String,
      imageUrl: fields[2] as String,
      currentPrice: fields[3] as double,
      inventoryAvailable: fields[4] == null ? 0 : fields[4] as double,
      inventorySold: fields[5] == null ? 0 : fields[5] as double,
      lastPurchasePrice: fields[6] == null ? 0 : fields[6] as double,
      allowedUnitIds:
          fields[7] == null ? [] : (fields[7] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.imageUrl)
      ..writeByte(3)
      ..write(obj.currentPrice)
      ..writeByte(4)
      ..write(obj.inventoryAvailable)
      ..writeByte(5)
      ..write(obj.inventorySold)
      ..writeByte(6)
      ..write(obj.lastPurchasePrice)
      ..writeByte(7)
      ..write(obj.allowedUnitIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
