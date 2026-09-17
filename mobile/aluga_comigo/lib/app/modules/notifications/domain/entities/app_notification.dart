enum AppNotificationType {
  like,
  superStar,
  superChat,
  questCompleted;

  static AppNotificationType fromString(String value) {
    return AppNotificationType.values.firstWhere(
      (item) => item.name == value,
      orElse: () => AppNotificationType.like,
    );
  }
}

class AppNotification {
  final String id;
  final AppNotificationType type;
  final String title;
  final String body;
  final DateTime? createdAt;

  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    this.createdAt,
  });
}
