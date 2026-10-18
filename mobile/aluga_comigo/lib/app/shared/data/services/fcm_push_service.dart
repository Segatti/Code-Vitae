import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../../../../firebase_config.dart';
import '../../domain/helpers/chat_notification_payload.dart';
import 'session_service.dart';
import 'supabase_database_service.dart';

typedef FcmChatTapHandler = Future<void> Function(String chatId);

class FcmPushService {
  final SupabaseDatabaseService _database;

  FcmPushService(this._database);

  bool _initialized = false;
  bool _backendRegistered = false;
  FcmChatTapHandler? _onChatTap;
  StreamSubscription<String>? _tokenRefreshSubscription;

  bool get isActive => _initialized && FirebaseConfig.isConfigured;

  /// Token registrado no Supabase (FCM remoto disponível).
  bool get hasBackendToken => _backendRegistered;

  Future<void> initialize({FcmChatTapHandler? onChatTap}) async {
    _onChatTap = onChatTap;
    if (_initialized) return;
    if (!FirebaseConfig.isConfigured) {
      developer.log(
        'Firebase não configurado — FCM desativado. Ver docs/fcm-setup.md',
        name: 'FcmPushService',
      );
      return;
    }

    final options = FirebaseConfig.currentPlatformOptions;
    if (options == null) return;

    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(options: options);
    }

    final messaging = FirebaseMessaging.instance;

    if (!kIsWeb && Platform.isIOS) {
      await messaging.requestPermission(alert: true, badge: true, sound: true);
    }

    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessageOpenedApp.listen(_handleRemoteMessage);
    final initial = await messaging.getInitialMessage();
    if (initial != null) {
      await _handleRemoteMessage(initial);
    }

    await _tokenRefreshSubscription?.cancel();
    _tokenRefreshSubscription = messaging.onTokenRefresh.listen(
      (token) => unawaited(_registerToken(token)),
    );

    _initialized = true;
  }

  Future<void> syncTokenWithBackend() async {
    if (!_initialized) return;
    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      await _registerToken(token);
    }
  }

  Future<void> _registerToken(String token) async {
    if (token.trim().isEmpty) return;
    if (SessionService.customer?.id == null) return;
    try {
      final platform = _platformName();
      await _database.upsertDevicePushToken(
        fcmToken: token,
        platform: platform,
      );
      _backendRegistered = true;
      developer.log('FCM token registrado', name: 'FcmPushService');
    } catch (error, stack) {
      developer.log(
        'Falha ao registrar FCM token: $error',
        name: 'FcmPushService',
        stackTrace: stack,
      );
    }
  }

  String _platformName() {
    if (kIsWeb) return 'web';
    if (Platform.isIOS) return 'ios';
    if (Platform.isAndroid) return 'android';
    return 'unknown';
  }

  Future<void> _handleRemoteMessage(RemoteMessage message) async {
    final chatId = _extractChatId(message);
    if (chatId == null) return;
    await _onChatTap?.call(chatId);
  }

  String? _extractChatId(RemoteMessage message) {
    final dataId = message.data['chatId']?.toString();
    if (dataId != null && dataId.isNotEmpty) return dataId;
    return ChatNotificationPayload.extractChatId(message.data['payload']);
  }

  Future<void> dispose() async {
    await _tokenRefreshSubscription?.cancel();
    _tokenRefreshSubscription = null;
  }
}
