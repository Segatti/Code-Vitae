import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:material_ui/material_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../supabase_config.dart';
import 'app_module.dart';
import 'app_widget.dart';
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

  runApp(
    ModularApp(
      module: AppModule(),
      navigatorKey: ModularNavigator.key,
      child: const AppWidget(),
    ),
  );
}
