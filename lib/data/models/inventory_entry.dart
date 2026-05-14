import 'package:hive/hive.dart';

part 'inventory_entry.g.dart';

@HiveType(typeId: 5)
class InventoryEntry extends HiveObject {
  InventoryEntry({
    required this.id,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.purchasePrice,
    required this.suggestedSalePrice,
    required this.marginPercent,
    required this.unitId,
    required this.unitLabel,
    required this.createdAt,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String productId;

  @HiveField(2)
  final String productName;

  @HiveField(3)
  final double quantity;

  @HiveField(4)
  final double purchasePrice;

  @HiveField(5)
  final double suggestedSalePrice;

  @HiveField(6)
  final double marginPercent;

  @HiveField(7)
  final String unitId;

  @HiveField(8)
  final String unitLabel;

  @HiveField(9)
  final DateTime createdAt;
}
