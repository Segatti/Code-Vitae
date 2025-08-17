import 'dart:convert';

import '../enums/type_answer.dart';
import '../enums/type_card.dart';

class CardLike {
  final int? id;
  final TypeCard? typeCard;
  final String? photo;
  final TypeAnswer? typeAnswer;
  
  const CardLike({
    this.id,
    this.typeCard,
    this.photo,
    this.typeAnswer,
  });

  CardLike copyWith({
    int? id,
    TypeCard? typeCard,
    String? photo,
    TypeAnswer? typeAnswer,
  }) {
    return CardLike(
      id: id ?? this.id,
      typeCard: typeCard ?? this.typeCard,
      photo: photo ?? this.photo,
      typeAnswer: typeAnswer ?? this.typeAnswer,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'typeCard': typeCard?.name,
      'photo': photo,
      'typeAnswer': typeAnswer?.name,
    };
  }

  factory CardLike.fromMap(Map<String, dynamic> map) {
    return CardLike(
      id: map['id'] != null ? map['id'] as int : null,
      typeCard: map['typeCard'] != null ? TypeCard.getType(map['typeCard'] as String) : null,
      photo: map['photo'] != null ? map['photo'] as String : null,
      typeAnswer: map['typeAnswer'] != null ? TypeAnswer.getType(map['typeAnswer'] as String) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CardLike.fromJson(String source) => CardLike.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CardLike(id: $id, typeCard: $typeCard, photo: $photo, typeAnswer: $typeAnswer)';
  }

  @override
  bool operator ==(covariant CardLike other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.typeCard == typeCard &&
      other.photo == photo &&
      other.typeAnswer == typeAnswer;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      typeCard.hashCode ^
      photo.hashCode ^
      typeAnswer.hashCode;
  }
}
