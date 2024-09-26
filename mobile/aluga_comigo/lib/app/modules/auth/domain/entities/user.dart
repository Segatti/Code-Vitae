import 'package:aluga_comigo/app/modules/auth/data/models/user_model.dart';

class User extends UserModel {
  User({
    super.email,
    super.password,
    super.typeUser,
    super.photo,
  });

  factory User.fromModel(UserModel model) {
    return User(
      email: model.email,
      password: model.password,
      typeUser: model.typeUser,
      photo: model.photo,
    );
  }

  UserModel toModel() {
    return UserModel(
      email: email,
      password: password,
      typeUser: typeUser,
      photo: photo,
    );
  }
}
