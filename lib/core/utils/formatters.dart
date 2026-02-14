import 'package:intl/intl.dart';

import 'package:cosecha_app/data/models/product.dart';
import 'package:cosecha_app/data/models/sale_transaction.dart';
import 'package:cosecha_app/core/services/business_session.dart';

const Set<String> _zeroDecimalCurrencyCodes = {
  'BIF',
  'CLP',
  'COP',
  'DJF',
  'GNF',
  'ISK',
  'JPY',
  'KMF',
  'KRW',
  'PYG',
  'RWF',
  'UGX',
  'VND',
  'VUV',
  'XAF',
  'XOF',
  'XPF',
};

int currencyDecimalDigitsForCode(String code) {
  if (_zeroDecimalCurrencyCodes.contains(code.toUpperCase())) return 0;
  return 2;
}

int currencyDecimalDigitsForCurrentBusiness() {
  final code = BusinessSession.instance.current?.currencyCode.trim() ?? '';
  return currencyDecimalDigitsForCode(code);
}

String formatCurrency(double amount) {
  final profile = BusinessSession.instance.current;
  final code = profile?.currencyCode.trim() ?? '';
  final decimalDigits = currencyDecimalDigitsForCode(code);
  final formatter = NumberFormat.decimalPatternDigits(
    locale: 'en_US',
    decimalDigits: decimalDigits,
  );
  if (profile == null) return formatter.format(amount);

  final symbol = (profile.currencySymbol ?? '').trim();
  final fallback = code;
  final prefix = symbol.isNotEmpty ? symbol : fallback;
  return prefix.isEmpty
      ? formatter.format(amount)
      : '$prefix ${formatter.format(amount)}';
}

String formatCurrencyCompact(double amount, {int? decimalDigits}) {
  final profile = BusinessSession.instance.current;
  final code = profile?.currencyCode.trim() ?? '';
  final currencyDigits = currencyDecimalDigitsForCode(code);
  final resolvedDigits = decimalDigits ?? currencyDigits;

  final formatter = NumberFormat.compact(locale: 'en_US')
    ..maximumFractionDigits = resolvedDigits
    ..minimumFractionDigits = 0;

  final compact = formatter.format(amount);
  if (profile == null) return compact;

  final symbol = (profile.currencySymbol ?? '').trim();
  final fallback = code;
  final prefix = symbol.isNotEmpty ? symbol : fallback;
  return prefix.isEmpty ? compact : '$prefix $compact';
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
