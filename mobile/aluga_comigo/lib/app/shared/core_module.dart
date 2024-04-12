import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';

class CoreModule extends Module {
  @override
  void exportedBinds(Injector i) {
    i.addSingleton<FlutterSecureStorage>(FlutterSecureStorage.new);
    i.addSingleton<FirebaseAuth>(() => FirebaseAuth.instance);
    i.addSingleton<FirebaseStorage>(() => FirebaseStorage.instance);
    i.addSingleton<FirebaseDatabase>(() => FirebaseDatabase.instance);
    i.addSingleton<ImagePicker>(ImagePicker.new);
  }
}
