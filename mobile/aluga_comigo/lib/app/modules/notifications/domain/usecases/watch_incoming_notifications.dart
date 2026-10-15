import '../entities/incoming_notification.dart';
import '../repositories/notification_repository.dart';

abstract interface class IWatchIncomingNotifications {
  Stream<IncomingNotification> call();
}

class WatchIncomingNotifications implements IWatchIncomingNotifications {
  final INotificationRepository repository;

  const WatchIncomingNotifications(this.repository);

  @override
  Stream<IncomingNotification> call() =>
      repository.watchIncomingNotifications();
}
