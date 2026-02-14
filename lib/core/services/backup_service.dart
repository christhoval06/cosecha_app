import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../data/hive/boxes.dart';
import '../../data/models/business.dart';
import '../../data/models/product.dart';
import '../../data/models/product_price_history.dart';
import '../../data/models/sale_transaction.dart';
import 'excel_export_service.dart';

class BackupService {
  BackupService._();

  static Future<String> exportToExcel() async {
    return ExcelExportService.exportToExcel();
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
    final file = File(
      '${appDir.path}/cosecha_backup_${DateTime.now().millisecondsSinceEpoch}.json',
    );
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

    final secretBox = SecretBox(cipherText, nonce: nonce, mac: Mac(macBytes));

    final clear = await algo.decrypt(secretBox, secretKey: key);
    final payload = jsonDecode(utf8.decode(clear)) as Map<String, dynamic>;
    await _restorePayload(payload);
  }

  static Map<String, dynamic> _buildPayload() {
    final imageAssets = <String, String>{};
    final business = Hive.box<Business>(
      HiveBoxes.business,
    ).get('current_profile');
    final businessLogoRef = _captureImageAsset(
      business?.logoPath,
      keyPrefix: 'business_logo',
      imageAssets: imageAssets,
    );

    final products = Hive.box<Product>(HiveBoxes.products).values
        .map(
          (p) => {
            'id': p.id,
            'name': p.name,
            'imageUrl': p.imageUrl,
            'imageRef': _captureImageAsset(
              p.imageUrl,
              keyPrefix: 'product_${p.id}',
              imageAssets: imageAssets,
            ),
            'currentPrice': p.currentPrice,
          },
        )
        .toList();

    final sales = Hive.box<SaleTransaction>(HiveBoxes.transactions).values
        .map(
          (s) => {
            'id': s.id,
            'productId': s.productId,
            'productName': s.productName,
            'amount': s.amount,
            'quantity': s.quantity,
            'channel': s.channel,
            'createdAt': s.createdAt.toIso8601String(),
          },
        )
        .toList();

    final history = Hive.box<ProductPriceHistory>(HiveBoxes.productPriceHistory)
        .values
        .map(
          (h) => {
            'id': h.id,
            'productId': h.productId,
            'price': h.price,
            'recordedAt': h.recordedAt.toIso8601String(),
            'strategyTags': h.strategyTags,
          },
        )
        .toList();

    return {
      'v': 2,
      'business': business == null
          ? null
          : {
              'id': business.id,
              'name': business.name,
              'logoPath': business.logoPath ?? '',
              'logoRef': businessLogoRef ?? '',
              'currencyCode': business.currencyCode,
              'currencySymbol': business.currencySymbol ?? '',
            },
      'products': products,
      'sales': sales,
      'priceHistory': history,
      'imageAssets': imageAssets,
    };
  }

  static Future<void> _restorePayload(Map<String, dynamic> payload) async {
    final businessRaw = payload['business'];
    final businessData = businessRaw is Map
        ? Map<String, dynamic>.from(businessRaw)
        : null;
    final products = (payload['products'] as List<dynamic>? ?? [])
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList(growable: false);
    final sales = (payload['sales'] as List<dynamic>? ?? [])
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList(growable: false);
    final history = (payload['priceHistory'] as List<dynamic>? ?? [])
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList(growable: false);
    final imageAssetsRaw = payload['imageAssets'];
    final imageAssets = imageAssetsRaw is Map
        ? Map<String, dynamic>.from(imageAssetsRaw)
        : <String, dynamic>{};

    final businessBox = Hive.box<Business>(HiveBoxes.business);
    final productBox = Hive.box<Product>(HiveBoxes.products);
    final salesBox = Hive.box<SaleTransaction>(HiveBoxes.transactions);
    final historyBox = Hive.box<ProductPriceHistory>(
      HiveBoxes.productPriceHistory,
    );

    final appDir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory(p.join(appDir.path, 'images'));
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }

    Future<String> restoreImagePath({
      required String? imageRef,
      required String? fallbackPath,
    }) async {
      final ref = imageRef?.trim() ?? '';
      if (ref.isNotEmpty) {
        final encoded = imageAssets[ref];
        if (encoded is String && encoded.isNotEmpty) {
          final fileName = p.basename(ref);
          final restoredFile = File(p.join(imagesDir.path, fileName));
          await restoredFile.writeAsBytes(base64Decode(encoded), flush: true);
          return restoredFile.path;
        }
      }

      final legacy = fallbackPath?.trim() ?? '';
      if (legacy.isNotEmpty && await File(legacy).exists()) {
        return legacy;
      }
      return '';
    }

    await businessBox.clear();
    await productBox.clear();
    await salesBox.clear();
    await historyBox.clear();

    if (businessData != null) {
      final restoredLogoPath = await restoreImagePath(
        imageRef: businessData['logoRef'] as String?,
        fallbackPath: businessData['logoPath'] as String?,
      );
      final business = Business(
        id: businessData['id'] as String? ?? 'current_profile',
        name: businessData['name'] as String? ?? '',
        logoPath: restoredLogoPath.isEmpty ? null : restoredLogoPath,
        currencyCode: businessData['currencyCode'] as String? ?? 'USD',
        currencySymbol:
            (businessData['currencySymbol'] as String?)?.isEmpty ?? true
            ? null
            : businessData['currencySymbol'] as String,
      );
      await businessBox.put('current_profile', business);
    }

    for (final p in products) {
      final restoredImagePath = await restoreImagePath(
        imageRef: p['imageRef'] as String?,
        fallbackPath: p['imageUrl'] as String?,
      );
      final product = Product(
        id: p['id'] as String,
        name: p['name'] as String,
        imageUrl: restoredImagePath,
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
        strategyTags: (h['strategyTags'] as List<dynamic>? ?? const [])
            .map((e) => e.toString())
            .toList(),
      );
      await historyBox.put(item.id, item);
    }
  }

  static String? _captureImageAsset(
    String? sourcePath, {
    required String keyPrefix,
    required Map<String, String> imageAssets,
  }) {
    final path = sourcePath?.trim() ?? '';
    if (path.isEmpty) return null;

    final sourceFile = File(path);
    if (!sourceFile.existsSync()) return null;

    final extension = p.extension(path);
    final normalizedPrefix = keyPrefix.replaceAll(
      RegExp(r'[^a-zA-Z0-9_-]'),
      '_',
    );

    var candidate = '$normalizedPrefix$extension';
    var suffix = 1;
    while (imageAssets.containsKey(candidate)) {
      candidate = '${normalizedPrefix}_$suffix$extension';
      suffix++;
    }

    final bytes = sourceFile.readAsBytesSync();
    imageAssets[candidate] = base64Encode(bytes);
    return candidate;
  }

  static Future<SecretKey> _deriveKey(String password, List<int> salt) async {
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
