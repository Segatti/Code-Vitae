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
  void register(ModularContext c) {
    c.addSingleton<FlutterSecureStorage>(FlutterSecureStorage.new);
    c.addSingleton<FirebaseAuth>(() => FirebaseAuth.instance);
    c.addSingleton<FirebaseStorage>(() => FirebaseStorage.instance);
    c.addSingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
    c.addSingleton<ImagePicker>(ImagePicker.new);
    c.addSingleton<SecureStorageService>(SecureStorageService.new);
    c.addSingleton<FirebaseDatabaseService>(FirebaseDatabaseService.new);
  }
}
