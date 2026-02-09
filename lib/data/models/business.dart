import 'package:hive/hive.dart';

part 'business.g.dart';

@HiveType(typeId: 0)
class Business extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? logoPath;

  @HiveField(3)
  final String currencyCode;

  @HiveField(4)
  final String? currencySymbol;

  Business({
    required this.id,
    required this.name,
    required this.logoPath,
    required this.currencyCode,
    this.currencySymbol,
  });
}
