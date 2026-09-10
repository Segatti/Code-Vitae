import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'data/services/camera_service.dart';
import 'data/services/secure_storage_service.dart';
import 'data/services/supabase_auth_service.dart';
import 'data/services/supabase_database_service.dart';
import 'data/services/supabase_storage_service.dart';

class CoreModule extends Module {
  @override
  void register(ModularContext c) {
    c.addSingleton<FlutterSecureStorage>(FlutterSecureStorage.new);
    c.addSingleton<SupabaseClient>(() => Supabase.instance.client);
    c.addSingleton<ImagePicker>(ImagePicker.new);
    c.addSingleton<SecureStorageService>(SecureStorageService.new);
    c.addSingleton<SupabaseDatabaseService>(SupabaseDatabaseService.new);
    c.addSingleton<SupabaseAuthService>(SupabaseAuthService.new);
    c.addSingleton<SupabaseStorageService>(SupabaseStorageService.new);
    c.addSingleton<CameraService>(CameraService.new);
  }
}
