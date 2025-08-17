import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'data/services/firebase_database_service.dart';
import 'data/services/secure_storage_service.dart';

class CoreModule extends Module {
  @override
  void exportedBinds(Injector i) {
    i.addSingleton<FlutterSecureStorage>(FlutterSecureStorage.new);
    i.addSingleton<FirebaseAuth>(() => FirebaseAuth.instance);
    i.addSingleton<FirebaseStorage>(() => FirebaseStorage.instance);
    i.addSingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
    i.addSingleton<ImagePicker>(ImagePicker.new);
    i.addSingleton<SecureStorageService>(SecureStorageService.new);
    i.addSingleton<FirebaseDatabaseService>(FirebaseDatabaseService.new);
  }
}
