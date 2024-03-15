import 'dart:convert';

import '../enums/type_reward.dart';

class Quest {
  final String? title;
  final bool? isCompleted;
  final int? amountRewards;
  final TypeRewards? typeRewards;
  final DateTime? completedAt;

  const Quest({
    this.title,
    this.isCompleted,
    this.amountRewards,
    this.typeRewards,
    this.completedAt,
  });

  Quest copyWith({
    String? title,
    bool? isCompleted,
    int? amountRewards,
    TypeRewards? typeRewards,
    DateTime? completedAt,
  }) {
    return Quest(
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      amountRewards: amountRewards ?? this.amountRewards,
      typeRewards: typeRewards ?? this.typeRewards,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'isCompleted': isCompleted,
      'amountRewards': amountRewards,
      'typeRewards': typeRewards?.name,
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory Quest.fromMap(Map<String, dynamic> map) {
    return Quest(
      title: map['title'] != null ? map['title'] as String : null,
      isCompleted: map['isCompleted'] != null ? map['isCompleted'] as bool : null,
      amountRewards: map['amountRewards'] != null ? map['amountRewards'] as int : null,
      typeRewards: map['typeRewards'] != null ? TypeRewards.getType(map['typeRewards'] as String) : null,
      completedAt: map['completedAt'] != null ? DateTime.parse(map['completedAt'] as String) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Quest.fromJson(String source) => Quest.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Quest(title: $title, isCompleted: $isCompleted, amountRewards: $amountRewards, typeRewards: $typeRewards, completedAt: $completedAt)';
  }

  @override
  bool operator ==(covariant Quest other) {
    if (identical(this, other)) return true;
  
    return 
      other.title == title &&
      other.isCompleted == isCompleted &&
      other.amountRewards == amountRewards &&
      other.typeRewards == typeRewards &&
      other.completedAt == completedAt;
  }

  @override
  int get hashCode {
    return title.hashCode ^
      isCompleted.hashCode ^
      amountRewards.hashCode ^
      typeRewards.hashCode ^
      completedAt.hashCode;
  }
}
