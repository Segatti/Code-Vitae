import 'dart:async';


import 'package:material_ui/material_ui.dart';

import '../../../../shared/data/services/local_push_notification_service.dart';
import '../../domain/entities/incoming_notification.dart';
import '../../domain/usecases/count_unread_notifications.dart';
import '../../domain/usecases/mark_notifications_viewed.dart';
import '../../domain/usecases/watch_incoming_notifications.dart';
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
  final IWatchIncomingNotifications _watchIncoming;
  final LocalPushNotificationService _localPush;

  NotificationsBadgeController(
    this._countUnread,
    this._watchUnread,
    this._markViewed,
    this._watchIncoming,
    this._localPush,
  );

  StreamSubscription<int>? _subscription;
  StreamSubscription<IncomingNotification>? _insertSubscription;

  @override
  Future<void> startWatching() async {
    if (isWatching) return;
    isWatching = true;

    await _localPush.initialize();

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

    await _insertSubscription?.cancel();
    _insertSubscription = _watchIncoming().listen((insert) {
      if (insert.notificationType != 'chatMessage') return;
      _localPush.showChatMessage(
        title: insert.title,
        body: insert.body,
      );
    });
  }

  @override
  Future<void> markViewed() async {
    await _markViewed();
    unreadCount = 0;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _insertSubscription?.cancel();
    super.dispose();
  }
}
