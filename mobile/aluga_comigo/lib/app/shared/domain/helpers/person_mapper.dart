import '../typedefs/json.dart';

class PersonMapper {
  static Json toAppMap(Json personRow, {Json? accountRow}) {
    final account = accountRow ?? personRow['accounts'] as Json?;
    return {
      'id': personRow['id']?.toString() ?? '',
      'email': account?['email'] ?? '',
      'password': '',
      'typeUser': 'person',
      'phone': account?['phone'] ?? '',
      'name': personRow['name'] ?? '',
      'state': personRow['state'] ?? '',
      'city': personRow['city'] ?? '',
      'photos': List<String>.from(personRow['photos'] ?? const []),
      'lastMatch': personRow['last_match_immobile_id']?.toString() ?? '',
      'shortDescription': personRow['short_description'] ?? '',
      'longDescription': personRow['long_description'] ?? '',
      'score': (personRow['score'] as num?)?.toDouble() ?? 0,
      'skills': List<String>.from(personRow['skills'] ?? const []),
      'dateBirth': personRow['date_birth'] ?? '',
      'priceMaxImmobile':
          (personRow['price_max_immobile'] as num?)?.toDouble() ?? 0,
      'desiredImmobile': personRow['desired_immobile'] ?? 'none',
      'lifeStyle': personRow['life_style'] ?? 'none',
      'gender': personRow['gender'] ?? '',
      'houseworks': List<String>.from(personRow['houseworks'] ?? const []),
      'isActive': account?['is_active'] ?? true,
    };
  }

  static Json toRow(Json appMap) {
    return {
      'id': appMap['id'],
      'name': appMap['name'] ?? '',
      'state': appMap['state'] ?? '',
      'city': appMap['city'] ?? '',
      'photos': appMap['photos'] ?? [],
      'short_description': appMap['shortDescription'] ?? '',
      'long_description': appMap['longDescription'] ?? '',
      'score': appMap['score'] ?? 0,
      'skills': appMap['skills'] ?? [],
      'date_birth': appMap['dateBirth'] ?? '',
      'price_max_immobile': appMap['priceMaxImmobile'] ?? 0,
      'desired_immobile': appMap['desiredImmobile'] ?? 'none',
      'life_style': appMap['lifeStyle'] ?? 'none',
      'gender': appMap['gender'] ?? '',
      'houseworks': appMap['houseworks'] ?? [],
      'last_match_immobile_id': _nullableUuid(appMap['lastMatch']),
    };
  }

  static String? _nullableUuid(dynamic value) {
    if (value == null) return null;
    final text = value.toString();
    return text.isEmpty ? null : text;
  }
}
