import 'dart:developer' as developer;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../../firebase_config.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (!FirebaseConfig.isConfigured) return;

  if (Firebase.apps.isEmpty) {
    final options = FirebaseConfig.currentPlatformOptions;
    if (options == null) return;
    await Firebase.initializeApp(options: options);
  }

  developer.log(
    'FCM background: ${message.messageId}',
    name: 'FcmBackground',
  );
}
