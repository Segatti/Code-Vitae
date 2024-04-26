import 'dart:convert';

class SelectItem {
  final String? title;
  final dynamic value;
  
  const SelectItem({
    required this.title,
    required this.value,
  });

  SelectItem copyWith({
    String? title,
    dynamic value,
  }) {
    return SelectItem(
      title: title ?? this.title,
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'value': value,
    };
  }

  factory SelectItem.fromMap(Map<String, dynamic> map) {
    return SelectItem(
      title: map['title'] != null ? map['title'] as String : null,
      value: map['value'] as dynamic,
    );
  }

  String toJson() => json.encode(toMap());

  factory SelectItem.fromJson(String source) => SelectItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'SelectItem(title: $title, value: $value)';

  @override
  bool operator ==(covariant SelectItem other) {
    if (identical(this, other)) return true;
  
    return 
      other.title == title &&
      other.value == value;
  }

  @override
  int get hashCode => title.hashCode ^ value.hashCode;
}
