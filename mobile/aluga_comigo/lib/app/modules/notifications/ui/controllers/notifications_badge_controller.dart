import 'dart:async';

import 'package:material_ui/material_ui.dart';

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

  NotificationsBadgeController(
    this._countUnread,
    this._watchUnread,
    this._markViewed,
  );

  StreamSubscription<int>? _subscription;

  @override
  Future<void> startWatching() async {
    if (isWatching) return;
    isWatching = true;

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
    super.dispose();
  }
}
