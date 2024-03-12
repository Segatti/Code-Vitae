import 'dart:convert';

import '../enums/home_type.dart';

class Contact {
  final String? name;
  final String? photo;
  final DateTime? birthday;
  final HomeType? homeType;

  const Contact({
    this.name,
    this.photo,
    this.birthday,
    this.homeType,
  });

  Contact copyWith({
    String? name,
    String? photo,
    DateTime? birthday,
    HomeType? homeType,
  }) {
    return Contact(
      name: name ?? this.name,
      photo: photo ?? this.photo,
      birthday: birthday ?? this.birthday,
      homeType: homeType ?? this.homeType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'photo': photo,
      'birthday': birthday?.toIso8601String(),
      'homeType': homeType?.name,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      name: map['name'] != null ? map['name'] as String : null,
      photo: map['photo'] != null ? map['photo'] as String : null,
      birthday: map['birthday'] != null
          ? DateTime.parse(map['birthday'] as String)
          : null,
      homeType:
          map['homeType'] != null ? HomeType.getType(map['homeType']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Contact.fromJson(String source) =>
      Contact.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Contact(name: $name, photo: $photo, birthday: $birthday, homeType: $homeType)';
  }

  @override
  bool operator ==(covariant Contact other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.photo == photo &&
        other.birthday == birthday &&
        other.homeType == homeType;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        photo.hashCode ^
        birthday.hashCode ^
        homeType.hashCode;
  }
}
