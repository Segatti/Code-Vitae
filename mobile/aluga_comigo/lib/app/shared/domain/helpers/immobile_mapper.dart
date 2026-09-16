import '../typedefs/json.dart';

class ImmobileMapper {
  static Json toAppMap(Json immobileRow, {Json? accountRow}) {
    final account = accountRow ?? immobileRow['accounts'] as Json?;
    return {
      'id': immobileRow['id']?.toString() ?? '',
      'email': account?['email'] ?? '',
      'password': '',
      'typeUser': 'immobile',
      'phone': account?['phone'] ?? '',
      'name': immobileRow['name'] ?? '',
      'state': immobileRow['state'] ?? '',
      'city': immobileRow['city'] ?? '',
      'photos': List<String>.from(immobileRow['photos'] ?? const []),
      'lastMatch': immobileRow['last_match_person_id']?.toString() ?? '',
      'shortDescription': immobileRow['short_description'] ?? '',
      'longDescription': immobileRow['long_description'] ?? '',
      'score': (immobileRow['score'] as num?)?.toDouble() ?? 0,
      'cep': immobileRow['cep'] ?? '',
      'price': (immobileRow['price'] as num?)?.toDouble() ?? 0,
      'typeImmobile': immobileRow['type_immobile'] ?? 'none',
      'bathrooms': immobileRow['bathrooms'] ?? 0,
      'bedrooms': immobileRow['bedrooms'] ?? 0,
      'carSpaces': immobileRow['car_spaces'] ?? 0,
      'isMarketNear': immobileRow['is_market_near'] ?? false,
      'isSchoolNear': immobileRow['is_school_near'] ?? false,
      'isHospitalNear': immobileRow['is_hospital_near'] ?? false,
      'isParkNear': immobileRow['is_park_near'] ?? false,
      'isGymNear': immobileRow['is_gym_near'] ?? false,
      'isMallNear': immobileRow['is_mall_near'] ?? false,
      'isBeachNear': immobileRow['is_beach_near'] ?? false,
      'isActive': account?['is_active'] ?? true,
      'powerUpUntil': immobileRow['power_up_until'],
    };
  }

  static Json toRow(Json appMap) {
    return {
      'id': appMap['id'],
      'name': appMap['name'] ?? appMap['shortDescription'] ?? '',
      'state': appMap['state'] ?? '',
      'city': appMap['city'] ?? '',
      'cep': appMap['cep'] ?? '',
      'photos': appMap['photos'] ?? [],
      'short_description': appMap['shortDescription'] ?? '',
      'long_description': appMap['longDescription'] ?? '',
      'score': appMap['score'] ?? 0,
      'price': appMap['price'] ?? 0,
      'type_immobile': appMap['typeImmobile'] ?? 'none',
      'bathrooms': appMap['bathrooms'] ?? 0,
      'bedrooms': appMap['bedrooms'] ?? 0,
      'car_spaces': appMap['carSpaces'] ?? 0,
      'is_market_near': appMap['isMarketNear'] ?? false,
      'is_school_near': appMap['isSchoolNear'] ?? false,
      'is_hospital_near': appMap['isHospitalNear'] ?? false,
      'is_park_near': appMap['isParkNear'] ?? false,
      'is_gym_near': appMap['isGymNear'] ?? false,
      'is_mall_near': appMap['isMallNear'] ?? false,
      'is_beach_near': appMap['isBeachNear'] ?? false,
      'last_match_person_id': _nullableUuid(appMap['lastMatch']),
    };
  }

  static String? _nullableUuid(dynamic value) {
    if (value == null) return null;
    final text = value.toString();
    return text.isEmpty ? null : text;
  }
}
