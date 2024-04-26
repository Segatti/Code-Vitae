import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../enums/type_immobile.dart';
import '../enums/type_user.dart';

class ImmobileSignupDTO {
  final TypeUser typeUser;
  final String? email;
  final String? password;
  final String? name;
  final String? phone;
  final String? cep;
  final num? value;
  final TypeImmobile? typeImmobile;
  final List<String>? photos;

  const ImmobileSignupDTO({
    this.typeUser = TypeUser.immobile,
    this.email,
    this.password,
    this.name,
    this.phone,
    this.cep,
    this.value,
    this.typeImmobile,
    this.photos,
  });

  ImmobileSignupDTO copyWith({
    TypeUser? typeUser,
    String? email,
    String? password,
    String? name,
    String? phone,
    String? cep,
    num? value,
    TypeImmobile? typeImmobile,
    List<String>? photos,
  }) {
    return ImmobileSignupDTO(
      typeUser: typeUser ?? this.typeUser,
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      cep: cep ?? this.cep,
      value: value ?? this.value,
      typeImmobile: typeImmobile ?? this.typeImmobile,
      photos: photos ?? this.photos,
    );
  }

  Map<String, dynamic> toMap({bool toDatabase = false}) {
    return <String, dynamic>{
      'typeUser': typeUser.name,
      if (!toDatabase) 'email': email,
      if (!toDatabase) 'password': password,
      'name': name,
      'phone': phone,
      'cep': cep,
      'value': value,
      'typeImmobile': typeImmobile?.name,
      'photos': photos,
    };
  }

  factory ImmobileSignupDTO.fromMap(Map<String, dynamic> map) {
    return ImmobileSignupDTO(
      typeUser: getTypeUser(map['typeUser'] as String),
      email: map['email'] != null ? map['email'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      cep: map['cep'] != null ? map['cep'] as String : null,
      value: map['value'] != null ? map['value'] as num : null,
      typeImmobile: getTypeImmobile(map['typeImmobile'] as String),
      photos: map['photos'] != null
          ? List<String>.from((map['photos'] as List<String>))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ImmobileSignupDTO.fromJson(String source) =>
      ImmobileSignupDTO.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ImmobileSignupDTO(typeUser: $typeUser, email: $email, password: $password, name: $name, phone: $phone, cep: $cep, value: $value, typeImmobile: $typeImmobile, photos: $photos)';
  }

  @override
  bool operator ==(covariant ImmobileSignupDTO other) {
    if (identical(this, other)) return true;

    return other.typeUser == typeUser &&
        other.email == email &&
        other.password == password &&
        other.name == name &&
        other.phone == phone &&
        other.cep == cep &&
        other.value == value &&
        other.typeImmobile == typeImmobile &&
        listEquals(other.photos, photos);
  }

  @override
  int get hashCode {
    return typeUser.hashCode ^
        email.hashCode ^
        password.hashCode ^
        name.hashCode ^
        phone.hashCode ^
        cep.hashCode ^
        value.hashCode ^
        typeImmobile.hashCode ^
        photos.hashCode;
  }
}
