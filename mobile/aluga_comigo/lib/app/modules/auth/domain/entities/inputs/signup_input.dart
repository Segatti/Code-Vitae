import '../../enums/type_immobile.dart';
import '../../enums/type_user.dart';
import '../../enums/user_skill.dart';

sealed class SignupInput {}

class SignupImmobileInput extends SignupInput {
  String email;
  String password;
  TypeUser typeUser;
  String name;
  String phone;
  String cep;
  num value;
  TypeImmobile? typeImmobile;
  String photo;

  SignupImmobileInput({
    this.email = "",
    this.password = "",
    this.typeUser = TypeUser.none,
    this.name = "",
    this.phone = "",
    this.cep = "",
    this.value = 0,
    this.typeImmobile,
    this.photo = "",
  });
}

class SignupUserInput extends SignupInput {
  String email;
  String password;
  TypeUser typeUser;
  String name;
  String phone;
  List<UserSkill> skills;
  String photo;

  SignupUserInput({
    this.email = "",
    this.password = "",
    this.typeUser = TypeUser.none,
    this.name = "",
    this.phone = "",
    this.skills = const [],
    this.photo = "",
  });
}
