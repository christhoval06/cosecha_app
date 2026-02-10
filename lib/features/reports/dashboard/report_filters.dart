import '../../../core/constants/sales_channels.dart';
import '../../../data/models/sale_transaction.dart';

class ReportFilters {
  const ReportFilters({
    required this.range,
    required this.from,
    required this.to,
    this.channel,
    this.productId,
    this.minAmount,
    this.maxAmount,
    this.minQuantity,
  });

  final String range;
  final DateTime from;
  final DateTime to;
  final String? channel;
  final String? productId;
  final double? minAmount;
  final double? maxAmount;
  final int? minQuantity;

  bool matchesSale(SaleTransaction sale) {
    if (channel != null && SalesChannels.normalize(sale.channel) != channel) {
      return false;
    }
    if (productId != null && sale.productId != productId) {
      return false;
    }
    if (minAmount != null && sale.amount < minAmount!) {
      return false;
    }
    if (maxAmount != null && sale.amount > maxAmount!) {
      return false;
    }
    if (minQuantity != null && sale.quantity < minQuantity!) {
      return false;
    }
    return true;
  }

  int get activeCount {
    var count = 0;
    if (channel != null) count++;
    if (productId != null) count++;
    if (minAmount != null) count++;
    if (maxAmount != null) count++;
    if (minQuantity != null) count++;
    return count;
  }
}
