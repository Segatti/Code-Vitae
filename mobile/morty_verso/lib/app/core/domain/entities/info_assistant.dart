class InfoAssistant {
  final int? count;
  final int? pages;
  final String? next;
  final String? prev;
  
  InfoAssistant({
    required this.count,
    required this.pages,
    required this.next,
    this.prev,
  });
}
