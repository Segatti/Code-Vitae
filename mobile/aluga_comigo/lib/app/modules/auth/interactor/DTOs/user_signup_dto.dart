import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../enums/type_user.dart';
import '../enums/user_skill.dart';

class UserSignupDTO {
  final TypeUser typeUser;
  final String? email;
  final String? password;
  final String? name;
  final String? phone;
  final List<UserSkill>? skills;
  final List<String>? photos;

  const UserSignupDTO({
    this.typeUser = TypeUser.person,
    this.email,
    this.password,
    this.name,
    this.phone,
    this.skills,
    this.photos,
  });

  UserSignupDTO copyWith({
    TypeUser? typeUser,
    String? email,
    String? password,
    String? name,
    String? phone,
    List<UserSkill>? skills,
    List<String>? photos,
  }) {
    return UserSignupDTO(
      typeUser: typeUser ?? this.typeUser,
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      skills: skills ?? this.skills,
      photos: photos ?? this.photos,
    );
  }

  Map<String, dynamic> toMap({bool toDatabase = false}) {
    return <String, dynamic>{
      if (!toDatabase) 'typeUser': typeUser.name,
      if (!toDatabase) 'email': email,
      if (!toDatabase) 'password': password,
      'name': name,
      'phone': phone,
      'skills': skills?.map((x) => x.name).toList(),
      if (!toDatabase) 'photos': photos,
    };
  }

  factory UserSignupDTO.fromMap(Map<String, dynamic> map) {
    return UserSignupDTO(
      typeUser: getTypeUser(map['typeUser']),
      email: map['email'] != null ? map['email'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      skills: map['skills'] != null
          ? (map['skills'] as List<String>).map((x) => getUserSkill(x)).toList()
          : [],
      photos: map['photos'] != null ? map['photos'] as List<String> : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserSignupDTO.fromJson(String source) =>
      UserSignupDTO.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserSignupDTO(typeUser: $typeUser, email: $email, password: $password, name: $name, phone: $phone, skills: $skills, photos: $photos)';
  }

  @override
  bool operator ==(covariant UserSignupDTO other) {
    if (identical(this, other)) return true;

    return other.typeUser == typeUser &&
        other.email == email &&
        other.password == password &&
        other.name == name &&
        other.phone == phone &&
        listEquals(other.skills, skills) &&
        listEquals(other.photos, photos);
  }

  @override
  int get hashCode {
    return typeUser.hashCode ^
        email.hashCode ^
        password.hashCode ^
        name.hashCode ^
        phone.hashCode ^
        skills.hashCode ^
        photos.hashCode;
  }
}
