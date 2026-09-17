import 'package:material_ui/material_ui.dart';
import 'package:result_dart/result_dart.dart';

import '../../domain/entities/app_notification.dart';
import '../../domain/usecases/list_notifications.dart';
import 'notifications_badge_controller.dart';

abstract interface class INotificationsController extends ChangeNotifier {
  List<String> loadingList = [];
  String errorMessage = '';
  List<AppNotification> items = [];

  Future<Unit> initialize();
}

class NotificationsController extends INotificationsController {
  final IListNotifications _listNotifications;
  final INotificationsBadgeController _badgeController;

  NotificationsController(this._listNotifications, this._badgeController);

  @override
  Future<Unit> initialize() async {
    loadingList.add('loadNotifications');
    errorMessage = '';
    notifyListeners();

    final result = await _listNotifications();

    loadingList.remove('loadNotifications');
    result.fold(
      (list) {
        items = list;
        errorMessage = '';
      },
      (_) {
        items = [];
        errorMessage = 'Erro ao carregar notificações';
      },
    );
    notifyListeners();
    await _badgeController.markViewed();
    return unit;
  }
}
