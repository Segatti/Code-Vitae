import '../repositories/notification_repository.dart';

abstract interface class ICountUnreadNotifications {
  Future<int> call();
}

class CountUnreadNotifications implements ICountUnreadNotifications {
  final INotificationRepository repository;

  const CountUnreadNotifications(this.repository);

  @override
  Future<int> call() => repository.countUnreadSinceLastView();
}
