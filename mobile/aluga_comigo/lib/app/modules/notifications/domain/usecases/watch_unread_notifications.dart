import '../repositories/notification_repository.dart';

abstract interface class IWatchUnreadNotifications {
  Stream<int> call();
}

class WatchUnreadNotifications implements IWatchUnreadNotifications {
  final INotificationRepository repository;

  const WatchUnreadNotifications(this.repository);

  @override
  Stream<int> call() => repository.watchUnreadCountSinceLastView();
}
