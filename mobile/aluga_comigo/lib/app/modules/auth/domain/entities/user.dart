import 'package:aluga_comigo/app/modules/auth/data/models/user_model.dart';

class User extends UserModel {
  User({
    super.id,
    super.email,
    super.password,
    super.typeUser,
    super.photo,
    super.lastMatch,
  });

  factory User.fromModel(UserModel model) {
    return User(
      id: model.id,
      email: model.email,
      password: model.password,
      typeUser: model.typeUser,
      photo: model.photo,
      lastMatch: model.lastMatch,
    );
  }

  UserModel toModel() {
    return UserModel(
      id: id,
      email: email,
      password: password,
      typeUser: typeUser,
      photo: photo,
      lastMatch: lastMatch,
    );
  }
}
