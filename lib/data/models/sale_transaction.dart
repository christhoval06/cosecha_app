import 'package:hive/hive.dart';

part 'sale_transaction.g.dart';

@HiveType(typeId: 3)
class SaleTransaction extends HiveObject {
  SaleTransaction({
    required this.id,
    required this.productName,
    required this.productId,
    required this.amount,
    required this.quantity,
    required this.channel,
    required this.createdAt,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String productName;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final int quantity;

  @HiveField(4)
  final String channel;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6, defaultValue: '')
  final String productId;
}
