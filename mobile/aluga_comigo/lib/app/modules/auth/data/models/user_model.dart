// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import '../../domain/enums/type_user.dart';

class UserModel {
  final String id;
  final String email;
  final String password;
  final TypeUser typeUser;
  final String photo;
  final String lastMatch;

  const UserModel({
    this.id = "",
    this.email = "",
    this.password = "",
    this.typeUser = TypeUser.none,
    this.photo = "",
    this.lastMatch = "",
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'password': password,
      'typeUser': typeUser.name,
      'photos': [photo],
      'lastMatch': lastMatch,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? "",
      email: map['email'] ?? "",
      password: map['password'] ?? "",
      typeUser: TypeUser.get(map['typeUser']),
      photo: map['photos']?[0] ?? "",
      lastMatch: map['lastMatch'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  UserModel copyWith({
    String? email,
    String? password,
    String? photo,
    String? lastMatch,
  }) {
    return UserModel(
      id: id,
      email: email ?? this.email,
      password: password ?? this.password,
      typeUser: typeUser,
      photo: photo ?? this.photo,
      lastMatch: lastMatch ?? this.lastMatch,
    );
  }
}
