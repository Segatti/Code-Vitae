import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class ImageHelper {
  static Future<File?> compressForUpload(File file) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final targetPath =
          '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 85,
        format: CompressFormat.jpeg,
        keepExif: false,
      );

      return compressedFile != null ? File(compressedFile.path) : null;
    } catch (_) {
      return null;
    }
  }
}
