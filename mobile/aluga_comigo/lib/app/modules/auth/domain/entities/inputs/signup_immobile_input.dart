import 'dart:io';

import '../../enums/type_immobile.dart';
import '../../enums/type_user.dart';

class SignupImmobileInput {
  const SignupImmobileInput(
    this.email,
    this.password,
    this.typeUser,
    this.name,
    this.phone,
    this.cep,
    this.value,
    this.typeImmobile,
    this.photo,
  );

  final String email;
  final String password;
  final TypeUser typeUser;
  final String name;
  final String phone;
  final String cep;
  final num value;
  final TypeImmobile typeImmobile;
  final File photo;
}
