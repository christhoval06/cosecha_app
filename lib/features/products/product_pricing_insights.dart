import '../../data/models/sale_transaction.dart';

class ProductPricingInsights {
  const ProductPricingInsights._();

  static double? suggestedPrice({
    required String productId,
    required String productName,
    required double currentPrice,
    required Iterable<SaleTransaction> sales,
    int recentDays = 30,
  }) {
    final since = DateTime.now().subtract(Duration(days: recentDays));
    final relevant = sales.where((sale) {
      final byId = productId.isNotEmpty && sale.productId == productId;
      final byName = sale.productId.isEmpty && sale.productName == productName;
      return (byId || byName) &&
          sale.quantity > 0 &&
          sale.createdAt.isAfter(since);
    }).toList();
    if (relevant.isEmpty) return null;

    final amount = relevant.fold<double>(0.0, (sum, item) => sum + item.amount);
    final quantity =
        relevant.fold<int>(0, (sum, item) => sum + item.quantity);
    if (quantity <= 0) return null;

    final avgUnitPrice = amount / quantity;
    if (avgUnitPrice <= 0) return null;

    // Smooth suggestion to avoid aggressive jumps.
    return ((avgUnitPrice * 0.7) + (currentPrice * 0.3));
  }
}
