import 'dart:io';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_ui/material_ui.dart';

import '../../data/services/camera_service.dart';
import '../../domain/helpers/card_flip_photo_dimensions.dart';
import '../widgets/app_camera_page.dart';

/// Seleciona e recorta fotos na proporção do flip card.
abstract final class CardFlipPhotoPicker {
  static Future<File?> pickSingle(
    BuildContext context, {
    required ImageSource source,
  }) async {
    final aspectRatio = _aspectRatio(context);

    if (source == ImageSource.camera) {
      final path = await AppCameraPage.capture(context);
      if (path == null || !context.mounted) return null;
      return _crop(File(path), aspectRatio: aspectRatio);
    }

    final picked = await inject<CameraService>().getImage(source);
    if (picked == null || !context.mounted) return null;
    return _crop(File(picked.path), aspectRatio: aspectRatio);
  }

  static Future<List<File>> pickMultiple(BuildContext context) async {
    final aspectRatio = _aspectRatio(context);
    final picked = await inject<CameraService>().getMultiImage();
    if (picked.isEmpty) return [];

    final cropped = <File>[];
    for (final file in picked) {
      if (!context.mounted) break;
      final result = await _crop(File(file.path), aspectRatio: aspectRatio);
      if (result != null) {
        cropped.add(result);
      }
    }
    return cropped;
  }

  static double _aspectRatio(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final photoHeight =
        size.height * CardFlipPhotoDimensions.cardHeightFactor -
        CardFlipPhotoDimensions.bottomOverlayHeight;
    final photoWidth = size.width - CardFlipPhotoDimensions.horizontalMargin;
    if (photoHeight <= 1 || photoWidth <= 1) {
      return CardFlipPhotoDimensions.fallbackAspectRatio;
    }
    return photoWidth / photoHeight;
  }

  static Future<File?> _crop(
    File source, {
    required double aspectRatio,
  }) async {
    const base = 1000.0;
    final ratioX = aspectRatio * base;
    const ratioY = base;

    final cropped = await ImageCropper().cropImage(
      sourcePath: source.path,
      aspectRatio: CropAspectRatio(
        ratioX: ratioX,
        ratioY: ratioY,
      ),
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 90,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Recortar foto',
          toolbarColor: const Color(0xFF2C29A3),
          toolbarWidgetColor: Colors.white,
          lockAspectRatio: true,
          hideBottomControls: false,
        ),
        IOSUiSettings(
          title: 'Recortar foto',
          aspectRatioLockEnabled: true,
          resetAspectRatioEnabled: false,
        ),
      ],
    );

    if (cropped == null) return null;
    return File(cropped.path);
  }
}
