// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import '../../domain/enums/type_user.dart';

class UserModel {
  final String email;
  final String password;
  final TypeUser typeUser;
  final String photo;

  const UserModel({
    this.email = "",
    this.password = "",
    this.typeUser = TypeUser.none,
    this.photo = "",
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'password': password,
      'typeUser': typeUser.name,
      'photo': photo,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] ?? "",
      password: map['password'] ?? "",
      typeUser: TypeUser.get(map['typeUser']),
      photo: map['photo'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
