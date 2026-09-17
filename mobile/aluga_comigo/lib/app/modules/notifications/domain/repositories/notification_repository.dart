import 'package:result_dart/result_dart.dart';

import '../entities/app_notification.dart';

abstract interface class INotificationRepository {
  AsyncResult<List<AppNotification>> listNotifications();

  Future<int> countUnreadSinceLastView();

  Stream<int> watchUnreadCountSinceLastView();

  Future<void> markNotificationsViewed();
}
