class Chat {
  final String id;
  final String personId;
  final String immobileId;
  final String otherName;
  final String otherPhoto;
  final String lastMessagePreview;
  final DateTime? lastMessageAt;

  const Chat({
    required this.id,
    required this.personId,
    required this.immobileId,
    required this.otherName,
    required this.otherPhoto,
    this.lastMessagePreview = '',
    this.lastMessageAt,
  });
}
