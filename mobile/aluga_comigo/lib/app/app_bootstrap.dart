import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:material_ui/material_ui.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../firebase_config.dart';
import '../supabase_config.dart';
import 'app_module.dart';
import 'app_widget.dart';
import 'modules/chats/chat_navigation.dart';
import 'shared/data/services/fcm_background_handler.dart';
import 'shared/data/services/firebase_observability_service.dart';
import 'shared/data/services/fcm_push_service.dart';
import 'shared/data/services/session_service.dart';
import 'shared/domain/entities/system_config.dart';
import 'shared/domain/usecases/load_system_config.dart';
import 'shared/navigation/modular_navigator.dart';

/// Supabase + [ModularApp]. Binding Flutter deve ser inicializado antes
/// ([MarionetteBinding] em `main`, [PatrolBinding] nos testes Patrol).
Future<void> bootstrapAlugaComigoApp() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Supabase.initialize(
    url: SupabaseConfig.url,
    publishableKey: SupabaseConfig.anonKey,
  );

  if (FirebaseConfig.isConfigured) {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    await FirebaseObservabilityService.ensureInitialized();
  }

  runApp(
    ModularApp(
      module: AppModule(),
      navigatorKey: ModularNavigator.key,
      child: const AppWidget(),
    ),
  );

  SchedulerBinding.instance.scheduleFrameCallback((_) async {
    await _loadSystemConfigAtStartup();
    if (FirebaseConfig.isConfigured) {
      final fcm = inject<FcmPushService>();
      await fcm.initialize(onChatTap: ChatNavigation.openById);
    }
  });
}

Future<void> _loadSystemConfigAtStartup() async {
  try {
    final load = inject<ILoadSystemConfig>();
    final result = await load();
    result.fold(
      SessionService.setSystemConfig,
      (_) => SessionService.setSystemConfig(SystemConfig.defaults()),
    );
  } catch (_) {
    SessionService.setSystemConfig(SystemConfig.defaults());
  }
}
