class IncomingNotification {
  final String notificationType;
  final String title;
  final String body;
  final String? referenceId;

  const IncomingNotification({
    required this.notificationType,
    required this.title,
    required this.body,
    this.referenceId,
  });
}
