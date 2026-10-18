import '../typedefs/json.dart';

class AccountMapper {
  static Json toRow(Json appMap) {
    final contactName = appMap['contactName']?.toString().trim() ??
        appMap['name']?.toString().trim() ??
        '';
    return {
      'id': appMap['id'],
      'email': appMap['email'],
      'type_user': appMap['typeUser'],
      'phone': appMap['phone'] ?? '',
      'contact_name': contactName,
      'is_active': appMap['isActive'] ?? true,
    };
  }
}
