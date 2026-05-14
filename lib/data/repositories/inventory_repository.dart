import 'package:hive/hive.dart';

import '../hive/boxes.dart';
import '../models/inventory_entry.dart';
import '../models/product.dart';

class InventoryRepository {
  Box<InventoryEntry> get _entries =>
      Hive.box<InventoryEntry>(HiveBoxes.inventoryEntries);
  Box<Product> get _products => Hive.box<Product>(HiveBoxes.products);

  List<InventoryEntry> getAllEntries() {
    final rows = _entries.values.toList();
    rows.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return rows;
  }

  Future<void> registerEntry(InventoryEntry entry) async {
    final id = entry.id.isNotEmpty
        ? entry.id
        : DateTime.now().millisecondsSinceEpoch.toString();
    await _entries.put(id, entry);
    final product = _products.get(entry.productId);
    if (product == null) return;
    final updated = Product(
      id: product.id,
      name: product.name,
      imageUrl: product.imageUrl,
      currentPrice: entry.suggestedSalePrice,
      inventoryAvailable: product.inventoryAvailable + entry.quantity,
      inventorySold: product.inventorySold,
      lastPurchasePrice: entry.purchasePrice,
      allowedUnitIds: product.allowedUnitIds,
    );
    await _products.put(product.id, updated);
  }
}
