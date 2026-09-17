import 'package:aluga_comigo/app/shared/data/services/session_service.dart';
import 'package:aluga_comigo/app/shared/domain/extends/result.dart';
import 'package:result_dart/result_dart.dart'
    hide FutureResultExtension, FutureResultExtensionVoid;

import '../../domain/entities/app_notification.dart';
import '../../domain/repositories/notification_repository.dart' as domain;
import '../datasources/notification_datasource.dart';
class NotificationRepository implements domain.INotificationRepository {
  final INotificationDatasource datasource;

  const NotificationRepository(this.datasource);

  String get _accountId => SessionService.customer!.id;

  @override
  AsyncResult<List<AppNotification>> listNotifications() async {
    return datasource
        .listNotifications()
        .then((models) => models.map((m) => m.toEntity()).toList())
        .toAsyncResult();
  }

  Future<DateTime> _unreadSinceThreshold() async {
    final lastViewed = await datasource.getLastViewedAt(_accountId);
    return lastViewed ?? DateTime.fromMillisecondsSinceEpoch(0);
  }

  @override
  Future<int> countUnreadSinceLastView() async {
    final since = await _unreadSinceThreshold();
    return datasource.countUnreadSince(_accountId, since);
  }

  @override
  Stream<int> watchUnreadCountSinceLastView() async* {
    yield await countUnreadSinceLastView();
    await for (final _ in datasource.watchNotificationChanges(_accountId)) {
      yield await countUnreadSinceLastView();
    }
  }

  @override
  Future<void> markNotificationsViewed() async {
    await datasource.setLastViewedAt(_accountId, DateTime.now().toUtc());
  }
}
