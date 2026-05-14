import 'package:hive/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 1)
class Product extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String imageUrl;

  @HiveField(3)
  final double currentPrice;

  @HiveField(4, defaultValue: 0)
  final double inventoryAvailable;

  @HiveField(5, defaultValue: 0)
  final double inventorySold;

  @HiveField(6, defaultValue: 0)
  final double lastPurchasePrice;

  @HiveField(7, defaultValue: <String>[])
  final List<String> allowedUnitIds;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.currentPrice,
    this.inventoryAvailable = 0,
    this.inventorySold = 0,
    this.lastPurchasePrice = 0,
    this.allowedUnitIds = const <String>[],
  });
}
