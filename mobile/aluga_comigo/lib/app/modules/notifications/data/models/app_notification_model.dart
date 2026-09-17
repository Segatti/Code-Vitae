import '../../domain/entities/app_notification.dart';

class AppNotificationModel {
  final String id;
  final String notificationType;
  final String title;
  final String body;
  final DateTime? createdAt;

  const AppNotificationModel({
    required this.id,
    required this.notificationType,
    required this.title,
    required this.body,
    this.createdAt,
  });

  factory AppNotificationModel.fromMap(Map<String, dynamic> map) {
    DateTime? createdAt;
    final raw = map['createdAt'];
    if (raw is String && raw.isNotEmpty) {
      createdAt = DateTime.tryParse(raw);
    }

    return AppNotificationModel(
      id: map['id']?.toString() ?? '',
      notificationType: map['notificationType']?.toString() ?? 'like',
      title: map['title']?.toString() ?? '',
      body: map['body']?.toString() ?? '',
      createdAt: createdAt,
    );
  }

  AppNotification toEntity() => AppNotification(
    id: id,
    type: AppNotificationType.fromString(notificationType),
    title: title,
    body: body,
    createdAt: createdAt,
  );
}
