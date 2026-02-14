import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

Future<String?> saveLocally(
  File imageFile, {
  String? fileNamePrefix,
  String folderName = 'images',
}) async {
  try {
    final appDocsDir = await getApplicationDocumentsDirectory();
    final targetDir = Directory(p.join(appDocsDir.path, folderName));
    if (!await targetDir.exists()) {
      await targetDir.create(recursive: true);
    }

    final extension = p.extension(imageFile.path).toLowerCase();
    final safeExtension = extension.isEmpty ? '.png' : extension;
    final baseName = (fileNamePrefix == null || fileNamePrefix.trim().isEmpty)
        ? DateTime.now().millisecondsSinceEpoch.toString()
        : fileNamePrefix.trim().replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');

    final fileName = '$baseName$safeExtension';
    final newPath = p.join(targetDir.path, fileName);
    final newFile = await imageFile.copy(newPath);

    return newFile.path;
  } catch (_) {
    // Intentionally swallow and return null to keep form flows resilient.
    return null;
  }
}

Future<String?> saveLocallyFromPath(
  String imagePath, {
  String? fileNamePrefix,
  String folderName = 'images',
}) async {
  try {
    final imageFile = File(imagePath);
    return await saveLocally(
      imageFile,
      fileNamePrefix: fileNamePrefix,
      folderName: folderName,
    );
  } catch (_) {
    return null;
  }
}
