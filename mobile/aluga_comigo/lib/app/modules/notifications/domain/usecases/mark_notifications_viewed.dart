import 'package:result_dart/result_dart.dart';

import '../repositories/notification_repository.dart';

abstract interface class IMarkNotificationsViewed {
  AsyncResult<Unit> call();
}

class MarkNotificationsViewed implements IMarkNotificationsViewed {
  final INotificationRepository repository;

  const MarkNotificationsViewed(this.repository);

  @override
  AsyncResult<Unit> call() async {
    try {
      await repository.markNotificationsViewed();
      return Success(unit);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }
}
