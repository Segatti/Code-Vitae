class NotificationInsertEvent {
  final String notificationType;
  final String title;
  final String body;

  const NotificationInsertEvent({
    required this.notificationType,
    required this.title,
    required this.body,
  });
}
