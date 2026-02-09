import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

Future<String?> saveLocally(File imageFile) async {
  try {
    final appDocsDir = await getApplicationDocumentsDirectory();

    final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
    final newPath = p.join(appDocsDir.path, fileName);
    final newFile = await imageFile.copy(newPath);

    return newFile.path;
  } catch (e) {
    print('Error al guardar la imagen: $e');
    return null;
  }
}

Future<String?> saveLocallyFromPath(String imagePath) async {
  try {
    final imageFile = File(imagePath);
    return await saveLocally(imageFile);
  } catch (e) {
    print('Error al guardar la imagen: $e');
    return null;
  }
}
