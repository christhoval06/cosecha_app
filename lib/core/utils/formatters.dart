import 'package:intl/intl.dart';

import 'package:cosecha_app/data/models/product.dart';
import 'package:cosecha_app/data/models/sale_transaction.dart';
import 'package:cosecha_app/core/services/business_session.dart';

String formatCurrency(double amount) {
  final formatter = NumberFormat('#,##0.00', 'en_US');

  final profile = BusinessSession.instance.current;
  if (profile == null) return formatter.format(amount);

  final symbol = (profile.currencySymbol ?? '').trim();
  final fallback = profile.currencyCode.trim();
  final prefix = symbol.isNotEmpty ? symbol : fallback;
  return prefix.isEmpty
      ? formatter.format(amount)
      : '$prefix ${formatter.format(amount)}';
}

extension ProductCurrency on Product {
  String formatAmount() => formatCurrency(currentPrice);
}

extension SaleTransactionCurrency on SaleTransaction {
  String formatAmount() => formatCurrency(amount);
}

String formatPercentDelta(double percent) {
  final sign = percent >= 0 ? '+' : '';
  final value = percent.abs().toStringAsFixed(1);
  return '$sign$value%';
}
