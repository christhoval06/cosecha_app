import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:excel/excel.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../../data/hive/boxes.dart';
import '../../data/models/product.dart';
import '../../data/models/product_price_history.dart';
import '../../data/models/sale_transaction.dart';
import '../utils/date_formatters.dart';

class BackupService {
  BackupService._();

  static Future<String> exportToExcel() async {
    final excel = Excel.createExcel();

    final productsSheet = excel['Products'];
    productsSheet.appendRow([
      TextCellValue('id'),
      TextCellValue('name'),
      TextCellValue('imageUrl'),
      TextCellValue('currentPrice'),
    ]);
    final products = Hive.box<Product>(HiveBoxes.products).values.toList();
    for (final p in products) {
      productsSheet.appendRow([
        TextCellValue(p.id),
        TextCellValue(p.name),
        TextCellValue(p.imageUrl),
        DoubleCellValue(p.currentPrice),
      ]);
    }

    final salesSheet = excel['Sales'];
    salesSheet.appendRow([
      TextCellValue('id'),
      TextCellValue('productId'),
      TextCellValue('productName'),
      TextCellValue('amount'),
      TextCellValue('quantity'),
      TextCellValue('channel'),
      TextCellValue('createdAt'),
    ]);
    final sales =
        Hive.box<SaleTransaction>(HiveBoxes.transactions).values.toList();
    for (final s in sales) {
      salesSheet.appendRow([
        TextCellValue(s.id),
        TextCellValue(s.productId),
        TextCellValue(s.productName),
        DoubleCellValue(s.amount),
        IntCellValue(s.quantity),
        TextCellValue(s.channel),
        TextCellValue(formatDateTimeYmdHm(s.createdAt)),
      ]);
    }

    final appDir = await getApplicationDocumentsDirectory();
    final file =
        File('${appDir.path}/cosecha_export_${DateTime.now().millisecondsSinceEpoch}.xlsx');
    file.createSync(recursive: true);
    file.writeAsBytesSync(excel.encode()!);
    return file.path;
  }

  static Future<String> exportEncryptedBackup(String password) async {
    final payload = _buildPayload();
    final json = jsonEncode(payload);

    final salt = _randomBytes(16);
    final nonce = _randomBytes(12);
    final key = await _deriveKey(password, salt);

    final algo = AesGcm.with256bits();
    final secretBox = await algo.encrypt(
      utf8.encode(json),
      secretKey: key,
      nonce: nonce,
    );

    final envelope = {
      'v': 1,
      'salt': base64Encode(salt),
      'nonce': base64Encode(nonce),
      'ciphertext': base64Encode(secretBox.cipherText),
      'mac': base64Encode(secretBox.mac.bytes),
    };

    final appDir = await getApplicationDocumentsDirectory();
    final file =
        File('${appDir.path}/cosecha_backup_${DateTime.now().millisecondsSinceEpoch}.json');
    file.createSync(recursive: true);
    await file.writeAsString(jsonEncode(envelope));
    return file.path;
  }

  static Future<void> restoreEncryptedBackup({
    required File file,
    required String password,
  }) async {
    final content = await file.readAsString();
    final data = jsonDecode(content) as Map<String, dynamic>;

    final salt = base64Decode(data['salt'] as String);
    final nonce = base64Decode(data['nonce'] as String);
    final cipherText = base64Decode(data['ciphertext'] as String);
    final macBytes = base64Decode(data['mac'] as String);

    final key = await _deriveKey(password, salt);
    final algo = AesGcm.with256bits();

    final secretBox = SecretBox(
      cipherText,
      nonce: nonce,
      mac: Mac(macBytes),
    );

    final clear = await algo.decrypt(secretBox, secretKey: key);
    final payload = jsonDecode(utf8.decode(clear)) as Map<String, dynamic>;
    await _restorePayload(payload);
  }

  static Map<String, dynamic> _buildPayload() {
    final products = Hive.box<Product>(HiveBoxes.products)
        .values
        .map((p) => {
              'id': p.id,
              'name': p.name,
              'imageUrl': p.imageUrl,
              'currentPrice': p.currentPrice,
            })
        .toList();

    final sales = Hive.box<SaleTransaction>(HiveBoxes.transactions)
        .values
        .map((s) => {
              'id': s.id,
              'productId': s.productId,
              'productName': s.productName,
              'amount': s.amount,
              'quantity': s.quantity,
              'channel': s.channel,
              'createdAt': s.createdAt.toIso8601String(),
            })
        .toList();

    final history =
        Hive.box<ProductPriceHistory>(HiveBoxes.productPriceHistory)
            .values
            .map((h) => {
                  'id': h.id,
                  'productId': h.productId,
                  'price': h.price,
                  'recordedAt': h.recordedAt.toIso8601String(),
                })
            .toList();

    return {
      'products': products,
      'sales': sales,
      'priceHistory': history,
    };
  }

  static Future<void> _restorePayload(Map<String, dynamic> payload) async {
    final products = (payload['products'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();
    final sales = (payload['sales'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();
    final history = (payload['priceHistory'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();

    final productBox = Hive.box<Product>(HiveBoxes.products);
    final salesBox = Hive.box<SaleTransaction>(HiveBoxes.transactions);
    final historyBox =
        Hive.box<ProductPriceHistory>(HiveBoxes.productPriceHistory);

    await productBox.clear();
    await salesBox.clear();
    await historyBox.clear();

    for (final p in products) {
      final product = Product(
        id: p['id'] as String,
        name: p['name'] as String,
        imageUrl: p['imageUrl'] as String? ?? '',
        currentPrice: (p['currentPrice'] as num).toDouble(),
      );
      await productBox.put(product.id, product);
    }

    for (final s in sales) {
      final sale = SaleTransaction(
        id: s['id'] as String,
        productId: s['productId'] as String? ?? '',
        productName: s['productName'] as String,
        amount: (s['amount'] as num).toDouble(),
        quantity: s['quantity'] as int,
        channel: s['channel'] as String,
        createdAt: DateTime.parse(s['createdAt'] as String),
      );
      await salesBox.put(sale.id, sale);
    }

    for (final h in history) {
      final item = ProductPriceHistory(
        id: h['id'] as String,
        productId: h['productId'] as String,
        price: (h['price'] as num).toDouble(),
        recordedAt: DateTime.parse(h['recordedAt'] as String),
      );
      await historyBox.put(item.id, item);
    }
  }

  static Future<SecretKey> _deriveKey(
    String password,
    List<int> salt,
  ) async {
    final pbkdf2 = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: 100000,
      bits: 256,
    );
    return pbkdf2.deriveKey(
      secretKey: SecretKey(utf8.encode(password)),
      nonce: salt,
    );
  }

  static List<int> _randomBytes(int length) {
    final rand = Random.secure();
    return List<int>.generate(length, (_) => rand.nextInt(256));
  }

}
