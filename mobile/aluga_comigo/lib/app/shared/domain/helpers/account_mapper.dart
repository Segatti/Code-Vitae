import '../typedefs/json.dart';

class AccountMapper {
  static Json toRow(Json appMap) {
    return {
      'id': appMap['id'],
      'email': appMap['email'],
      'type_user': appMap['typeUser'],
      'phone': appMap['phone'] ?? '',
      'is_active': appMap['isActive'] ?? true,
    };
  }
}
