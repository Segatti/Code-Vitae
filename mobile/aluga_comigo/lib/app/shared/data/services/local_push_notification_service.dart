import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../domain/helpers/chat_notification_payload.dart';

typedef ChatMessageNotificationTap = void Function(String chatId);

class LocalPushNotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  ChatMessageNotificationTap? _onChatMessageTap;

  Future<void> initialize({ChatMessageNotificationTap? onChatMessageTap}) async {
    if (_initialized) {
      _onChatMessageTap = onChatMessageTap;
      return;
    }

    _onChatMessageTap = onChatMessageTap;

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);

    await _plugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );
    _initialized = true;

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      await androidPlugin?.requestNotificationsPermission();
    }
  }

  Future<void> processLaunchNotification() async {
    if (!_initialized) return;
    final details = await _plugin.getNotificationAppLaunchDetails();
    if (details?.didNotificationLaunchApp != true) return;
    _dispatchTap(details?.notificationResponse?.payload);
  }

  void _onNotificationResponse(NotificationResponse response) {
    _dispatchTap(response.payload);
  }

  void _dispatchTap(String? payload) {
    final chatId = ChatNotificationPayload.extractChatId(payload);
    if (chatId == null) return;
    _onChatMessageTap?.call(chatId);
  }

  Future<void> showChatMessage({
    required String title,
    required String body,
    required String chatId,
  }) async {
    if (!_initialized) {
      await initialize();
    }
    if (chatId.isEmpty) return;

    const androidDetails = AndroidNotificationDetails(
      'chat_messages',
      'Mensagens do chat',
      channelDescription: 'Novas mensagens recebidas no chat',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.show(
      id: chatId.hashCode & 0x7fffffff,
      title: title,
      body: body.isEmpty ? 'Nova mensagem' : body,
      notificationDetails: details,
      payload: ChatNotificationPayload.encodeChatMessage(chatId: chatId),
    );
  }
}
