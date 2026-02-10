import 'package:hive/hive.dart';

import '../hive/boxes.dart';
import '../models/sale_transaction.dart';

class ReportsRepository {
  Box<SaleTransaction> get _box =>
      Hive.box<SaleTransaction>(HiveBoxes.transactions);

  List<SaleTransaction> _salesInRange(
    DateTime from,
    DateTime to, {
    bool Function(SaleTransaction sale)? where,
  }) {
    return _box.values
        .where((s) => s.createdAt.isAfter(from) && s.createdAt.isBefore(to))
        .where((s) => where?.call(s) ?? true)
        .toList();
  }

  double totalAmount(
    DateTime from,
    DateTime to, {
    bool Function(SaleTransaction sale)? where,
  }) {
    return _salesInRange(from, to, where: where).fold(0, (sum, s) => sum + s.amount);
  }

  int totalCount(
    DateTime from,
    DateTime to, {
    bool Function(SaleTransaction sale)? where,
  }) {
    return _salesInRange(from, to, where: where).length;
  }

  ChannelBreakdown channelBreakdown(
    DateTime from,
    DateTime to, {
    bool Function(SaleTransaction sale)? where,
  }) {
    final sales = _salesInRange(from, to, where: where);
    var retail = 0.0;
    var wholesale = 0.0;
    var other = 0.0;

    for (final sale in sales) {
      switch (_normalizeChannel(sale.channel)) {
        case 'retail':
          retail += sale.amount;
          break;
        case 'wholesale':
          wholesale += sale.amount;
          break;
        default:
          other += sale.amount;
          break;
      }
    }

    return ChannelBreakdown(
      retail: retail,
      wholesale: wholesale,
      other: other,
    );
  }

  Map<DateTime, double> dailyTotals(
    DateTime from,
    DateTime to, {
    bool Function(SaleTransaction sale)? where,
  }) {
    final Map<DateTime, double> buckets = {};
    final sales = _salesInRange(from, to, where: where);
    for (final s in sales) {
      final day = DateTime(s.createdAt.year, s.createdAt.month, s.createdAt.day);
      buckets[day] = (buckets[day] ?? 0) + s.amount;
    }
    return buckets;
  }

  List<double> dailySeries(
    DateTime from,
    DateTime to, {
    bool Function(SaleTransaction sale)? where,
  }) {
    final totals = dailyTotals(from, to, where: where);
    final days = _daysBetween(from, to);
    return days.map((d) => totals[d] ?? 0).toList();
  }

  List<TopProduct> topProducts(
    DateTime from,
    DateTime to, {
    int limit = 5,
    bool Function(SaleTransaction sale)? where,
  }) {
    final list = productTotals(from, to, where: where)
      ..sort((a, b) => b.amount.compareTo(a.amount));
    return list.take(limit).toList();
  }

  List<TopProduct> bottomProducts(
    DateTime from,
    DateTime to, {
    int limit = 5,
    bool Function(SaleTransaction sale)? where,
  }) {
    final list = productTotals(from, to, where: where)
      ..sort((a, b) => a.amount.compareTo(b.amount));
    return list.take(limit).toList();
  }

  List<TopProduct> productTotals(
    DateTime from,
    DateTime to, {
    bool Function(SaleTransaction sale)? where,
  }) {
    final sales = _salesInRange(from, to, where: where);
    final Map<String, TopProduct> map = {};
    for (final s in sales) {
      final key = s.productId.isNotEmpty ? s.productId : s.productName;
      final entry = map.putIfAbsent(
        key,
        () => TopProduct(
          productId: key,
          name: s.productName,
          amount: 0,
          quantity: 0,
        ),
      );
      map[key] = entry.copyWith(
        amount: entry.amount + s.amount,
        quantity: entry.quantity + s.quantity,
      );
    }
    return map.values.toList();
  }

  List<MonthlyTotal> monthlyTotalsLastMonths({
    int months = 6,
    DateTime? reference,
    bool Function(SaleTransaction sale)? where,
  }) {
    final now = reference ?? DateTime.now();
    final start = DateTime(now.year, now.month - (months - 1), 1);
    final endExclusive = DateTime(now.year, now.month + 1, 1);

    final buckets = <DateTime, double>{};
    for (var i = 0; i < months; i++) {
      final monthStart = DateTime(start.year, start.month + i, 1);
      buckets[monthStart] = 0;
    }

    for (final sale in _box.values) {
      if (!(where?.call(sale) ?? true)) continue;
      final createdAt = sale.createdAt;
      if (createdAt.isBefore(start) || !createdAt.isBefore(endExclusive)) {
        continue;
      }
      final monthStart = DateTime(createdAt.year, createdAt.month, 1);
      if (!buckets.containsKey(monthStart)) continue;
      buckets[monthStart] = (buckets[monthStart] ?? 0) + sale.amount;
    }

    return buckets.entries
        .map((entry) => MonthlyTotal(monthStart: entry.key, total: entry.value))
        .toList()
      ..sort((a, b) => a.monthStart.compareTo(b.monthStart));
  }

  List<DateTime> _daysBetween(DateTime from, DateTime to) {
    final start = DateTime(from.year, from.month, from.day);
    final end = DateTime(to.year, to.month, to.day);
    final days = <DateTime>[];
    var current = start;
    while (!current.isAfter(end)) {
      days.add(current);
      current = current.add(const Duration(days: 1));
    }
    return days;
  }

  String _normalizeChannel(String value) {
    switch (value) {
      case 'Retail':
        return 'retail';
      case 'Wholesale':
        return 'wholesale';
      default:
        return value;
    }
  }
}

class TopProduct {
  TopProduct({
    required this.productId,
    required this.name,
    required this.amount,
    required this.quantity,
  });

  final String productId;
  final String name;
  final double amount;
  final int quantity;

  TopProduct copyWith({double? amount, int? quantity}) {
    return TopProduct(
      productId: productId,
      name: name,
      amount: amount ?? this.amount,
      quantity: quantity ?? this.quantity,
    );
  }
}

class MonthlyTotal {
  MonthlyTotal({
    required this.monthStart,
    required this.total,
  });

  final DateTime monthStart;
  final double total;
}

class ChannelBreakdown {
  ChannelBreakdown({
    required this.retail,
    required this.wholesale,
    required this.other,
  });

  final double retail;
  final double wholesale;
  final double other;

  double get total => retail + wholesale + other;
}
