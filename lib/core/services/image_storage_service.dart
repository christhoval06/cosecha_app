import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImageStorageService {
  ImageStorageService._();

  static final ImagePicker _picker = ImagePicker();

  static Future<String?> pickAndSaveImage({
    required ImageSource source,
    int imageQuality = 85,
    double? maxWidth,
    double? maxHeight,
  }) async {
    final picked = await _picker.pickImage(
      source: source,
      imageQuality: imageQuality,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
    );

    if (picked == null) return null;

    final appDir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory('${appDir.path}/images');
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }

    final extension = _fileExtension(picked.path);
    final fileName = 'img_${DateTime.now().millisecondsSinceEpoch}$extension';
    final savedPath = '${imagesDir.path}/$fileName';

    final savedFile = await File(picked.path).copy(savedPath);
    return savedFile.path;
  }

  static String _fileExtension(String path) {
    final dotIndex = path.lastIndexOf('.');
    if (dotIndex == -1) return '';
    return path.substring(dotIndex);
  }
}
