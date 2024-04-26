import '../enums/type_user.dart';

class User {
  const User(this.email, this.password, this.typeUser, this.photo);

  final String email;
  final String password;
  final TypeUser typeUser;
  final String photo;
}
