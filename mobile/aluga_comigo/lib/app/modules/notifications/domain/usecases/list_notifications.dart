import 'package:result_dart/result_dart.dart';

import '../entities/app_notification.dart';
import '../repositories/notification_repository.dart';

abstract interface class IListNotifications {
  AsyncResult<List<AppNotification>> call();
}

class ListNotifications implements IListNotifications {
  final INotificationRepository repository;

  const ListNotifications(this.repository);

  @override
  AsyncResult<List<AppNotification>> call() {
    return repository.listNotifications();
  }
}
