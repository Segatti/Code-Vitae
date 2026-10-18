import 'dart:async';

import 'package:material_ui/material_ui.dart';

import '../../../chats/chat_navigation.dart';
import '../../../chats/presenter/active_chat_session.dart';
import '../../../../shared/data/models/chat_message_insert_event.dart';
import '../../../../shared/data/services/fcm_push_service.dart';
import '../../../../shared/data/services/local_push_notification_service.dart';
import '../../../../shared/data/services/session_service.dart';
import '../../../../shared/data/services/supabase_realtime_service.dart';
import '../../../../shared/presenter/lifecycle/app_lifecycle_bridge.dart';
import '../../domain/usecases/count_unread_notifications.dart';
import '../../domain/usecases/mark_notifications_viewed.dart';
import '../../domain/usecases/watch_unread_notifications.dart';

abstract interface class INotificationsBadgeController extends ChangeNotifier {
  int unreadCount = 0;
  bool isWatching = false;

  Future<void> startWatching();
  Future<void> markViewed();
  @override
  void dispose();
}

class NotificationsBadgeController extends INotificationsBadgeController {
  final ICountUnreadNotifications _countUnread;
  final IWatchUnreadNotifications _watchUnread;
  final IMarkNotificationsViewed _markViewed;
  final LocalPushNotificationService _localPush;
  final SupabaseRealtimeService _realtime;
  final FcmPushService _fcmPush;

  NotificationsBadgeController(
    this._countUnread,
    this._watchUnread,
    this._markViewed,
    this._localPush,
    this._realtime,
    this._fcmPush,
  );

  StreamSubscription<int>? _subscription;
  StreamSubscription<ChatMessageInsertEvent>? _chatMessageSubscription;

  String? _lastPushChatId;
  DateTime? _lastPushAt;

  @override
  Future<void> startWatching() async {
    if (isWatching) return;
    isWatching = true;

    await _localPush.initialize(onChatMessageTap: ChatNavigation.openById);
    await _localPush.processLaunchNotification();
    await _fcmPush.syncTokenWithBackend();

    AppLifecycleBridge.addResumeListener(_onAppResume);

    unreadCount = await _countUnread();
    notifyListeners();

    await _subscription?.cancel();
    _subscription = _watchUnread().listen(
      (count) {
        unreadCount = count;
        notifyListeners();
      },
      onError: (_) {},
    );

    await _chatMessageSubscription?.cancel();
    final accountId = SessionService.customer?.id ?? '';
    if (accountId.isNotEmpty) {
      _chatMessageSubscription =
          _realtime.watchIncomingChatMessages(accountId).listen((event) {
        _maybeShowChatPush(
          chatId: event.chatId,
          title: 'Nova mensagem',
          body: event.preview,
        );
      });
    }
  }

  void _onAppResume() {
    unawaited(_realtime.resumeFromBackground());
    unawaited(_fcmPush.syncTokenWithBackend());
  }

  void _maybeShowChatPush({
    required String chatId,
    required String title,
    required String body,
  }) {
    if (ActiveChatSession.openChatId == chatId) return;
    if (_fcmPush.hasBackendToken) return;
    if (AppLifecycleBridge.isForeground) return;

    final now = DateTime.now();
    if (_lastPushChatId == chatId &&
        _lastPushAt != null &&
        now.difference(_lastPushAt!) < const Duration(seconds: 4)) {
      return;
    }
    _lastPushChatId = chatId;
    _lastPushAt = now;

    unawaited(
      _localPush.showChatMessage(
        title: title,
        body: body,
        chatId: chatId,
      ),
    );
  }

  @override
  Future<void> markViewed() async {
    await _markViewed();
    unreadCount = 0;
    notifyListeners();
  }

  @override
  void dispose() {
    AppLifecycleBridge.removeResumeListener(_onAppResume);
    _subscription?.cancel();
    _chatMessageSubscription?.cancel();
    super.dispose();
  }
}
