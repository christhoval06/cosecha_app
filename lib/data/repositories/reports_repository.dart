import 'package:hive/hive.dart';

import '../hive/boxes.dart';
import '../models/sale_transaction.dart';

class ReportsRepository {
  Box<SaleTransaction> get _box =>
      Hive.box<SaleTransaction>(HiveBoxes.transactions);

  List<SaleTransaction> _salesInRange(DateTime from, DateTime to) {
    return _box.values
        .where((s) => s.createdAt.isAfter(from) && s.createdAt.isBefore(to))
        .toList();
  }

  double totalAmount(DateTime from, DateTime to) {
    return _salesInRange(from, to).fold(0, (sum, s) => sum + s.amount);
  }

  int totalCount(DateTime from, DateTime to) {
    return _salesInRange(from, to).length;
  }

  Map<DateTime, double> dailyTotals(DateTime from, DateTime to) {
    final Map<DateTime, double> buckets = {};
    final sales = _salesInRange(from, to);
    for (final s in sales) {
      final day = DateTime(s.createdAt.year, s.createdAt.month, s.createdAt.day);
      buckets[day] = (buckets[day] ?? 0) + s.amount;
    }
    return buckets;
  }

  List<double> dailySeries(DateTime from, DateTime to) {
    final totals = dailyTotals(from, to);
    final days = _daysBetween(from, to);
    return days.map((d) => totals[d] ?? 0).toList();
  }

  List<TopProduct> topProducts(DateTime from, DateTime to, {int limit = 5}) {
    final sales = _salesInRange(from, to);
    final Map<String, TopProduct> map = {};
    for (final s in sales) {
      final entry = map.putIfAbsent(
        s.productId,
        () => TopProduct(
          productId: s.productId,
          name: s.productName,
          amount: 0,
          quantity: 0,
        ),
      );
      map[s.productId] = entry.copyWith(
        amount: entry.amount + s.amount,
        quantity: entry.quantity + s.quantity,
      );
    }
    final list = map.values.toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));
    return list.take(limit).toList();
  }

  List<MonthlyTotal> monthlyTotalsLastMonths({
    int months = 6,
    DateTime? reference,
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
