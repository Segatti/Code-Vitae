import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'data/datasources/system_config_datasource.dart';
import 'data/repositories/system_config_repository.dart';
import 'data/repositories/terms_acceptance_repository.dart';
import 'data/services/aluga_comigo_api_client.dart';
import 'domain/repositories/system_config_repository.dart' as domain;
import 'domain/usecases/load_system_config.dart';
import 'domain/repositories/terms_acceptance_repository.dart';
import 'domain/usecases/check_terms_acceptance_required.dart';
import 'domain/usecases/record_terms_acceptance.dart';
import 'data/services/camera_service.dart';
import 'data/services/secure_storage_service.dart';
import 'data/services/supabase_auth_service.dart';
import 'data/services/supabase_database_service.dart';
import 'data/services/supabase_realtime_service.dart';
import 'data/services/fcm_push_service.dart';
import 'data/services/local_push_notification_service.dart';
import 'data/services/supabase_storage_service.dart';

class CoreModule extends Module {
  @override
  void register(ModularContext c) {
    c.addSingleton<FlutterSecureStorage>(FlutterSecureStorage.new);
    c.addSingleton<SupabaseClient>(() => Supabase.instance.client);
    c.addSingleton<ImagePicker>(ImagePicker.new);
    c.addSingleton<SecureStorageService>(SecureStorageService.new);
    c.addSingleton<AlugaComigoApiClient>(
      () => AlugaComigoApiClient(supabase: Supabase.instance.client),
    );
    c.addSingleton<SupabaseDatabaseService>(SupabaseDatabaseService.new);
    c.addSingleton<ISystemConfigDatasource>(SystemConfigDatasource.new);
    c.addSingleton<domain.ISystemConfigRepository>(SystemConfigRepository.new);
    c.addSingleton<ILoadSystemConfig>(LoadSystemConfig.new);
    c.addSingleton<ITermsAcceptanceRepository>(TermsAcceptanceRepository.new);
    c.addSingleton<ICheckTermsAcceptanceRequired>(
      CheckTermsAcceptanceRequired.new,
    );
    c.addSingleton<IRecordTermsAcceptance>(RecordTermsAcceptance.new);
    c.addSingleton<SupabaseRealtimeService>(SupabaseRealtimeService.new);
    c.addSingleton<SupabaseAuthService>(SupabaseAuthService.new);
    c.addSingleton<SupabaseStorageService>(SupabaseStorageService.new);
    c.addSingleton<CameraService>(CameraService.new);
    c.addSingleton<LocalPushNotificationService>(
      LocalPushNotificationService.new,
    );
    c.addSingleton<FcmPushService>(FcmPushService.new);
  }
}
