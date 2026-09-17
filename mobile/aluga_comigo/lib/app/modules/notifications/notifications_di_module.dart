import 'package:aluga_comigo/app/modules/notifications/data/datasources/notification_datasource.dart';
import 'package:aluga_comigo/app/modules/notifications/data/repositories/notification_repository.dart';
import 'package:aluga_comigo/app/modules/notifications/domain/repositories/notification_repository.dart'
    as domain;
import 'package:aluga_comigo/app/modules/notifications/domain/usecases/count_unread_notifications.dart';
import 'package:aluga_comigo/app/modules/notifications/domain/usecases/list_notifications.dart';
import 'package:aluga_comigo/app/modules/notifications/domain/usecases/mark_notifications_viewed.dart';
import 'package:aluga_comigo/app/modules/notifications/domain/usecases/watch_unread_notifications.dart';
import 'package:aluga_comigo/app/modules/notifications/ui/controllers/notifications_badge_controller.dart';
import 'package:aluga_comigo/app/modules/notifications/ui/controllers/notifications_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

class NotificationsDiModule extends Module {
  @override
  void register(ModularContext c) {
    c.addSingleton<INotificationDatasource>(NotificationDatasource.new);
    c.addSingleton<domain.INotificationRepository>(NotificationRepository.new);
    c.addSingleton<IListNotifications>(ListNotifications.new);
    c.addSingleton<ICountUnreadNotifications>(CountUnreadNotifications.new);
    c.addSingleton<IWatchUnreadNotifications>(WatchUnreadNotifications.new);
    c.addSingleton<IMarkNotificationsViewed>(MarkNotificationsViewed.new);
    c.addLazySingleton<INotificationsController>(NotificationsController.new);
    c.addLazySingleton<INotificationsBadgeController>(
      NotificationsBadgeController.new,
    );
  }
}
