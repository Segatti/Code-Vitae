import 'dart:async';

import '../../../../shared/data/services/secure_storage_service.dart';
import '../../../../shared/data/services/session_service.dart';
import '../../../../shared/data/services/supabase_database_service.dart';
import '../../../../shared/data/services/supabase_realtime_service.dart';
import '../models/app_notification_model.dart';

abstract interface class INotificationDatasource {
  Future<List<AppNotificationModel>> listNotifications();

  Future<DateTime?> getLastViewedAt(String accountId);

  Future<void> setLastViewedAt(String accountId, DateTime viewedAt);

  Future<int> countUnreadSince(String accountId, DateTime after);

  Stream<void> watchNotificationChanges(String accountId);
}

class NotificationDatasource implements INotificationDatasource {
  final SupabaseDatabaseService database;
  final SupabaseRealtimeService realtime;
  final SecureStorageService storage;

  const NotificationDatasource(this.database, this.realtime, this.storage);

  static String _lastViewedKey(String accountId) =>
      'notifications_last_viewed_$accountId';

  @override
  Future<List<AppNotificationModel>> listNotifications() async {
    final userId = SessionService.customer!.id;
    final rows = await database.listUserNotifications(userId);
    return rows.map(AppNotificationModel.fromMap).toList();
  }

  @override
  Future<DateTime?> getLastViewedAt(String accountId) async {
    final raw = await storage.getDataByKey(_lastViewedKey(accountId));
    if (raw == null || raw.isEmpty) return null;
    return DateTime.tryParse(raw);
  }

  @override
  Future<void> setLastViewedAt(String accountId, DateTime viewedAt) async {
    await storage.setDataByKey(
      _lastViewedKey(accountId),
      viewedAt.toUtc().toIso8601String(),
    );
  }

  @override
  Future<int> countUnreadSince(String accountId, DateTime after) {
    return database.countUserNotificationsAfter(
      accountId: accountId,
      after: after,
    );
  }

  @override
  Stream<void> watchNotificationChanges(String accountId) {
    return realtime.watchUserNotifications(accountId);
  }
}
