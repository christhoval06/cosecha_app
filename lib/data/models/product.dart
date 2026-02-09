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

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.currentPrice,
  });
}
