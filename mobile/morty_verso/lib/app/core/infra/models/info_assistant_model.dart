import 'dart:convert';
import '../../domain/entities/info_assistant.dart';

class InfoAssistantModel extends InfoAssistant {
  InfoAssistantModel({
    super.count,
    super.pages,
    super.next,
    super.prev,
  });

  InfoAssistantModel copyWith({
    int? count,
    int? pages,
    String? next,
    String? prev,
  }) {
    return InfoAssistantModel(
      count: count ?? this.count,
      pages: pages ?? this.pages,
      next: next ?? this.next,
      prev: prev ?? this.prev,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'count': count,
      'pages': pages,
      'next': next,
      'prev': prev,
    };
  }

  factory InfoAssistantModel.fromMap(Map<String, dynamic> map) {
    return InfoAssistantModel(
      count: map['count'] as int,
      pages: map['pages'] as int,
      next: map['next'] != null ? map['next'] as String : null,
      prev: map['prev'] != null ? map['prev'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory InfoAssistantModel.fromJson(String source) =>
      InfoAssistantModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'InfoAssistantModel(count: $count, pages: $pages, next: $next, prev: $prev)';
  }

  @override
  bool operator ==(covariant InfoAssistantModel other) {
    if (identical(this, other)) return true;

    return other.count == count &&
        other.pages == pages &&
        other.next == next &&
        other.prev == prev;
  }

  @override
  int get hashCode {
    return count.hashCode ^ pages.hashCode ^ next.hashCode ^ prev.hashCode;
  }
}
