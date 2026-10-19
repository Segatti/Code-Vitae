import 'dart:developer' as developer;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import '../../../../firebase_config.dart';

/// Inicializa Firebase (se necessário), Crashlytics e handlers globais de erro.
abstract final class FirebaseObservabilityService {
  static var _initialized = false;

  static Future<void> ensureInitialized() async {
    if (_initialized || !FirebaseConfig.isConfigured || kIsWeb) return;

    final options = FirebaseConfig.currentPlatformOptions;
    if (options == null) return;

    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(options: options);
    }

    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
      !kDebugMode,
    );

    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    _initialized = true;
    developer.log('Crashlytics ativo', name: 'FirebaseObservabilityService');
  }

  static Future<void> recordError(
    Object error,
    StackTrace stack, {
    bool fatal = false,
  }) async {
    if (!_initialized || kDebugMode) return;
    await FirebaseCrashlytics.instance.recordError(
      error,
      stack,
      fatal: fatal,
    );
  }
}
