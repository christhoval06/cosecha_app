import 'package:hive/hive.dart';

part 'product_price_history.g.dart';

@HiveType(typeId: 2)
class ProductPriceHistory extends HiveObject {
  ProductPriceHistory({
    required this.id,
    required this.productId,
    required this.price,
    required this.recordedAt,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String productId;

  @HiveField(2)
  final double price;

  @HiveField(3)
  final DateTime recordedAt;
}
