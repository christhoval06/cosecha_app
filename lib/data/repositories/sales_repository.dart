import 'package:hive/hive.dart';

import '../hive/boxes.dart';
import '../models/product.dart';
import '../models/sale_transaction.dart';

class SalesRepository {
  Box<SaleTransaction> get _box =>
      Hive.box<SaleTransaction>(HiveBoxes.transactions);
  Box<Product> get _productBox => Hive.box<Product>(HiveBoxes.products);

  List<SaleTransaction> getAll() => _box.values.toList();

  Future<void> save(SaleTransaction sale) async {
    final resolved = _withId(sale);
    await _box.put(resolved.id, resolved);
  }

  List<SaleTransaction> getByRange(DateTime from) {
    final items = _box.values
        .where((item) => item.createdAt.isAfter(from))
        .toList();
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return items;
  }

  SalesPeriodSummary getPeriodSummary(DateTime from, DateTime to) {
    final current = _sumBetween(from, to);
    final duration = to.difference(from);
    final prevFrom = from.subtract(duration);
    final prevTo = from;
    final previous = _sumBetween(prevFrom, prevTo);
    final double deltaPercent = previous == 0
        ? (current == 0 ? 0 : 100)
        : ((current - previous) / previous) * 100;
    return SalesPeriodSummary(
      current: current,
      previous: previous,
      deltaPercent: deltaPercent,
    );
  }

  double _sumBetween(DateTime from, DateTime to) {
    return _box.values
        .where(
          (item) => item.createdAt.isAfter(from) && item.createdAt.isBefore(to),
        )
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  List<Product> getTopProducts({int limit = 3}) {
    final products = _productBox.values.toList();
    final sales = _box.values.toList();
    if (products.isEmpty) return [];
    if (sales.isEmpty) return products.take(limit).toList();

    final Map<String, int> totals = {};
    for (final sale in sales) {
      if (sale.productId.isEmpty) continue;
      totals[sale.productId] = (totals[sale.productId] ?? 0) + sale.quantity;
    }

    final sortedIds = totals.keys.toList()
      ..sort((a, b) => (totals[b] ?? 0).compareTo(totals[a] ?? 0));

    final List<Product> top = [];
    for (final id in sortedIds) {
      final product = products.firstWhere(
        (p) => p.id == id,
        orElse: () => products.first,
      );
      if (!top.contains(product)) {
        top.add(product);
      }
      if (top.length == limit) break;
    }

    if (top.length < limit) {
      for (final product in products) {
        if (!top.contains(product)) {
          top.add(product);
        }
        if (top.length == limit) break;
      }
    }

    return top;
  }

  SaleTransaction _withId(SaleTransaction sale) {
    if (sale.id.isNotEmpty) return sale;
    return SaleTransaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      productName: sale.productName,
      productId: sale.productId,
      amount: sale.amount,
      quantity: sale.quantity,
      channel: sale.channel,
      createdAt: sale.createdAt,
    );
  }
}

class SalesPeriodSummary {
  SalesPeriodSummary({
    required this.current,
    required this.previous,
    required this.deltaPercent,
  });

  final double current;
  final double previous;
  final double deltaPercent;
}
