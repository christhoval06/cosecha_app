import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../data/hive/boxes.dart';
import '../../data/models/business.dart';
import '../../data/models/product.dart';

class ImagePathRepairService {
  ImagePathRepairService._();

  static Future<void> repairIfNeeded() async {
    final appDocsDir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory(p.join(appDocsDir.path, 'images'));
    final productsBox = Hive.box<Product>(HiveBoxes.products);
    final businessBox = Hive.box<Business>(HiveBoxes.business);

    await _repairBusinessLogo(
      appDocsDir: appDocsDir,
      imagesDir: imagesDir,
      businessBox: businessBox,
    );

    await _repairProducts(
      appDocsDir: appDocsDir,
      imagesDir: imagesDir,
      productsBox: productsBox,
    );
  }

  static Future<void> _repairBusinessLogo({
    required Directory appDocsDir,
    required Directory imagesDir,
    required Box<Business> businessBox,
  }) async {
    final business = businessBox.get('current_profile');
    final logoPath = business?.logoPath?.trim() ?? '';
    if (business == null || logoPath.isEmpty || await File(logoPath).exists()) {
      return;
    }

    final recovered = await _findCandidatePath(
      rawPath: logoPath,
      preferredPrefix: 'business_current_profile',
      appDocsDir: appDocsDir,
      imagesDir: imagesDir,
    );
    if (recovered == null) return;

    await businessBox.put(
      'current_profile',
      Business(
        id: business.id,
        name: business.name,
        logoPath: recovered,
        currencyCode: business.currencyCode,
        currencySymbol: business.currencySymbol,
      ),
    );
  }

  static Future<void> _repairProducts({
    required Directory appDocsDir,
    required Directory imagesDir,
    required Box<Product> productsBox,
  }) async {
    for (final product in productsBox.values.toList(growable: false)) {
      final imagePath = product.imageUrl.trim();
      if (imagePath.isEmpty || await File(imagePath).exists()) {
        continue;
      }

      final recovered = await _findCandidatePath(
        rawPath: imagePath,
        preferredPrefix: 'product_${product.id}',
        appDocsDir: appDocsDir,
        imagesDir: imagesDir,
      );
      if (recovered == null) continue;

      await productsBox.put(
        product.id,
        Product(
          id: product.id,
          name: product.name,
          imageUrl: recovered,
          currentPrice: product.currentPrice,
        ),
      );
    }
  }

  static Future<String?> _findCandidatePath({
    required String rawPath,
    required String preferredPrefix,
    required Directory appDocsDir,
    required Directory imagesDir,
  }) async {
    final rawFileName = p.basename(rawPath);
    final rawExt = p.extension(rawPath).toLowerCase();

    final inImagesByName = File(p.join(imagesDir.path, rawFileName));
    if (await inImagesByName.exists()) return inImagesByName.path;

    final inDocsByName = File(p.join(appDocsDir.path, rawFileName));
    if (await inDocsByName.exists()) return inDocsByName.path;

    if (await imagesDir.exists()) {
      final files = imagesDir
          .listSync(followLinks: false)
          .whereType<File>()
          .toList(growable: false);

      final byPrefix = files
          .where((file) {
            final name = p.basenameWithoutExtension(file.path);
            if (!name.startsWith(preferredPrefix)) return false;
            if (rawExt.isEmpty) return true;
            return p.extension(file.path).toLowerCase() == rawExt;
          })
          .toList(growable: false);

      if (byPrefix.isNotEmpty) {
        byPrefix.sort((a, b) => a.path.compareTo(b.path));
        return byPrefix.first.path;
      }
    }

    return null;
  }
}
