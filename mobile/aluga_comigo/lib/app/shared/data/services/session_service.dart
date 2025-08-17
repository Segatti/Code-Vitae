import 'package:aluga_comigo/app/modules/auth/domain/entities/user.dart';

class SessionService {
  static User? user;
  static void setUser(User data) {
    user = data;
  }

  static void clearUser() {
    user = null;
  }
}
