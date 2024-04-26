import 'dart:io';

import '../../enums/type_user.dart';
import '../../enums/user_skill.dart';

class SignupUserInput {
  const SignupUserInput(
    this.email,
    this.password,
    this.typeUser,
    this.name,
    this.phone,
    this.skills,
    this.photo,
  );

  final String email;
  final String password;
  final TypeUser typeUser;
  final String name;
  final String phone;
  final List<UserSkill> skills;
  final File photo;
}
