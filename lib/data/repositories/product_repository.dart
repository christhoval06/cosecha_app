import 'package:hive/hive.dart';

import '../hive/boxes.dart';
import '../models/product.dart';
import '../models/product_price_history.dart';

class ProductRepository {
  Box<Product> get _productBox => Hive.box<Product>(HiveBoxes.products);
  Box<ProductPriceHistory> get _historyBox =>
      Hive.box<ProductPriceHistory>(HiveBoxes.productPriceHistory);

  List<Product> getAll() => _productBox.values.toList();

  Product? getById(String id) => _productBox.get(id);

  List<ProductPriceHistory> getHistory(String productId) {
    final items = _historyBox.values
        .where((item) => item.productId == productId)
        .toList();
    items.sort((a, b) => a.recordedAt.compareTo(b.recordedAt));
    return items;
  }

  Future<void> save(
    Product product, {
    List<String> priceChangeTags = const <String>[],
  }) async {
    final resolved = _withId(product);
    final existing = _productBox.get(resolved.id);
    await _productBox.put(resolved.id, resolved);

    if (existing == null || existing.currentPrice != resolved.currentPrice) {
      await _savePriceHistory(
        productId: resolved.id,
        price: resolved.currentPrice,
        strategyTags: priceChangeTags,
      );
    }
  }

  Future<void> delete(String id) async {
    await _productBox.delete(id);
  }

  Future<void> _savePriceHistory({
    required String productId,
    required double price,
    required List<String> strategyTags,
  }) async {
    final timestamp = DateTime.now();
    final history = ProductPriceHistory(
      id: '${productId}_${timestamp.millisecondsSinceEpoch}',
      productId: productId,
      price: price,
      recordedAt: timestamp,
      strategyTags: strategyTags,
    );
    await _historyBox.put(history.id, history);
  }

  Product _withId(Product product) {
    if (product.id.isNotEmpty) return product;
    return Product(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: product.name,
      imageUrl: product.imageUrl,
      currentPrice: product.currentPrice,
    );
  }
}
