import 'package:image_picker/image_picker.dart';

class CameraService {
  final ImagePicker _picker;

  const CameraService(this._picker);

  Future<XFile?> getImage(ImageSource cameraSource) async {
    return await _picker.pickImage(source: cameraSource);
  }

  Future<XFile?> getVideo(ImageSource cameraSource) async {
    return await _picker.pickVideo(source: cameraSource);
  }

  Future<List<XFile>> getMultiImage() async {
    return await _picker.pickMultiImage();
  }
}
