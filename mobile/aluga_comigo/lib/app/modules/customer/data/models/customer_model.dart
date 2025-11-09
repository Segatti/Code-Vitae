import 'dart:convert';

import 'package:aluga_comigo/app/shared/domain/extends/map_convert.dart';

import '../../../auth/domain/enums/type_immobile.dart';
import '../../../auth/domain/enums/type_user.dart';
import '../../../auth/domain/enums/user_desired_immobile.dart';
import '../../../auth/domain/enums/user_housework.dart';
import '../../../auth/domain/enums/user_life_style.dart';
import '../../../auth/domain/enums/user_skill.dart';

sealed class CustomerModel {
  final String id;
  final String email;
  final String password;
  final TypeUser typeUser;
  final String phone;
  final String lastMatch;
  final String shortDescription;
  final String longDescription;
  final double score;
  final String cityState;
  final List<String> photos;

  CustomerModel({
    this.id = "",
    this.email = "",
    this.password = "",
    this.typeUser = TypeUser.none,
    this.phone = "",
    this.lastMatch = "",
    this.cityState = "",
    this.shortDescription = "",
    this.longDescription = "",
    this.score = 0,
    this.photos = const [],
  });

  Map<String, dynamic> toMap() {
    var splitCityState = cityState.split(' - ');
    var city = splitCityState[0];
    var state = splitCityState[1];
    return <String, dynamic>{
      'id': id,
      'email': email,
      'password': password,
      'typeUser': typeUser.name,
      'phone': phone,
      'lastMatch': lastMatch,
      'shortDescription': shortDescription,
      'longDescription': longDescription,
      'score': score,
      'city': city,
      'state': state,
      'photos': photos,
    };
  }

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    var typeUser = TypeUser.get(map.getSafe<String>('typeUser'));
    if (typeUser == TypeUser.person) {
      return PersonCustomerModel.fromMap(map);
    } else {
      return ImmobileCustomerModel.fromMap(map);
    }
  }

  String toJson();

  factory CustomerModel.fromJson(String jsonString) {
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    var typeUser = TypeUser.get(json.getSafe<String>('typeUser'));
    if (typeUser == TypeUser.person) {
      return PersonCustomerModel.fromMap(json);
    } else {
      return ImmobileCustomerModel.fromMap(json);
    }
  }
}

class PersonCustomerModel extends CustomerModel {
  final String name;
  final List<UserHousework> houseworks;
  final List<UserSkill> skills;
  final String dateBirth;
  final double priceMaxImmobile;
  final UserDesiredImmobile desiredImmobile;
  final UserLifeStyle lifeStyle;
  final String gender;

  PersonCustomerModel({
    super.id = "",
    super.email = "",
    super.password = "",
    super.typeUser = TypeUser.none,
    this.name = "",
    super.phone = "",
    this.houseworks = const [],
    this.skills = const [],
    super.lastMatch = "",
    this.dateBirth = "",
    super.photos = const [],
    super.shortDescription = "",
    super.longDescription = "",
    super.score = 0,
    this.priceMaxImmobile = 0,
    super.cityState = "",
    this.desiredImmobile = UserDesiredImmobile.none,
    this.lifeStyle = UserLifeStyle.none,
    this.gender = "",
  });

  @override
  Map<String, dynamic> toMap() {
    var splitCityState = cityState.split(' - ');
    var city = splitCityState[0];
    var state = splitCityState[1];
    return <String, dynamic>{
      'id': id,
      'email': email,
      'password': password,
      'typeUser': typeUser.name,
      'name': name,
      'phone': phone,
      'houseworks': houseworks.map((e) => e.name).toList(),
      'skills': skills.map((e) => e.name).toList(),
      'photos': photos,
      'lastMatch': lastMatch,
      'dateBirth': dateBirth,
      'shortDescription': shortDescription,
      'longDescription': longDescription,
      'score': score,
      'priceMaxImmobile': priceMaxImmobile,
      'city': city,
      'state': state,
      'desiredImmobile': desiredImmobile.name,
      'lifeStyle': lifeStyle.name,
      'gender': gender,
    };
  }

  factory PersonCustomerModel.fromMap(Map<String, dynamic> map) {
    var city = map.getSafe<String>('city');
    var state = map.getSafe<String>('state');
    var cityState = '$city - $state';
    return PersonCustomerModel(
      id: map.getSafe<String>('id'),
      email: map.getSafe<String>('email'),
      password: map.getSafe<String>('password'),
      typeUser: TypeUser.get(map.getSafe<String>('typeUser')),
      name: map.getSafe<String>('name'),
      phone: map.getSafe<String>('phone'),
      houseworks: map
          .getList<String>('houseworks')
          .map((e) => UserHousework.get(e))
          .toList()
          .cast<UserHousework>(),
      skills: map
          .getList<String>('skills')
          .map((e) => UserSkill.get(e))
          .toList()
          .cast<UserSkill>(),
      photos: map.getList<String>('photos'),
      lastMatch: map.getSafe<String>('lastMatch'),
      dateBirth: map.getSafe<String>('dateBirth'),
      shortDescription: map.getSafe<String>('shortDescription'),
      longDescription: map.getSafe<String>('longDescription'),
      score: map.getSafe<double>('score'),
      priceMaxImmobile: map.getSafe<double>('priceMaxImmobile'),
      cityState: cityState,
      desiredImmobile: UserDesiredImmobile.get(
        map.getSafe<String>('desiredImmobile'),
      ),
      lifeStyle: UserLifeStyle.get(map.getSafe<String>('lifeStyle')),
      gender: map.getSafe<String>('gender'),
    );
  }

  @override
  String toJson() {
    return jsonEncode(toMap());
  }

  factory PersonCustomerModel.fromJson(String jsonString) {
    final json = jsonDecode(jsonString);
    return PersonCustomerModel.fromMap(json);
  }

  PersonCustomerModel copyWith({
    String? id,
    String? email,
    String? password,
    String? name,
    String? phone,
    List<UserHousework>? houseworks,
    List<UserSkill>? skills,
    List<String>? photos,
    String? lastMatch,
    String? dateBirth,
    String? shortDescription,
    String? longDescription,
    double? score,
    double? priceMaxImmobile,
    String? cityState,
    UserDesiredImmobile? desiredImmobile,
    UserLifeStyle? lifeStyle,
    String? gender,
  }) {
    return PersonCustomerModel(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      houseworks: houseworks ?? this.houseworks,
      skills: skills ?? this.skills,
      photos: photos ?? this.photos,
      lastMatch: lastMatch ?? this.lastMatch,
      dateBirth: dateBirth ?? this.dateBirth,
      shortDescription: shortDescription ?? this.shortDescription,
      longDescription: longDescription ?? this.longDescription,
      score: score ?? this.score,
      priceMaxImmobile: priceMaxImmobile ?? this.priceMaxImmobile,
      cityState: cityState ?? this.cityState,
      desiredImmobile: desiredImmobile ?? this.desiredImmobile,
      lifeStyle: lifeStyle ?? UserLifeStyle.none,
      gender: gender ?? this.gender,
    );
  }
}

class ImmobileCustomerModel extends CustomerModel {
  final String cep;
  final int bathrooms;
  final int bedrooms;
  final int carSpaces;
  final bool isMarketNear;
  final bool isSchoolNear;
  final bool isHospitalNear;
  final bool isParkNear;
  final bool isGymNear;
  final bool isMallNear;
  final bool isBeachNear;
  final double price;
  final TypeImmobile typeImmobile;

  ImmobileCustomerModel({
    super.id = "",
    super.email = "",
    super.password = "",
    super.typeUser = TypeUser.none,
    super.phone = "",
    super.photos = const [],
    super.lastMatch = "",
    super.shortDescription = "",
    super.longDescription = "",
    super.score = 0,
    this.price = 0,
    this.typeImmobile = TypeImmobile.none,
    super.cityState = "",
    this.cep = "",
    this.bathrooms = 0,
    this.bedrooms = 0,
    this.carSpaces = 0,
    this.isMarketNear = false,
    this.isSchoolNear = false,
    this.isHospitalNear = false,
    this.isParkNear = false,
    this.isGymNear = false,
    this.isMallNear = false,
    this.isBeachNear = false,
  });

  @override
  Map<String, dynamic> toMap() {
    var splitCityState = cityState.split(' - ');
    var city = splitCityState[0];
    var state = splitCityState[1];
    return <String, dynamic>{
      'id': id,
      'email': email,
      'password': password,
      'typeUser': typeUser.name,
      'phone': phone,
      'photos': photos,
      'lastMatch': lastMatch,
      'shortDescription': shortDescription,
      'longDescription': longDescription,
      'score': score,
      'price': price,
      'city': city,
      'state': state,
      'typeImmobile': typeImmobile.name,
      'cep': cep,
      'bathrooms': bathrooms,
      'bedrooms': bedrooms,
      'carSpaces': carSpaces,
      'isMarketNear': isMarketNear,
      'isSchoolNear': isSchoolNear,
      'isHospitalNear': isHospitalNear,
      'isParkNear': isParkNear,
      'isGymNear': isGymNear,
      'isMallNear': isMallNear,
      'isBeachNear': isBeachNear,
    };
  }

  factory ImmobileCustomerModel.fromMap(Map<String, dynamic> map) {
    var city = map.getSafe<String>('city');
    var state = map.getSafe<String>('state');
    var cityState = '$city - $state';
    return ImmobileCustomerModel(
      id: map.getSafe<String>('id'),
      email: map.getSafe<String>('email'),
      password: map.getSafe<String>('password'),
      typeUser: TypeUser.get(map.getSafe<String>('typeUser')),
      phone: map.getSafe<String>('phone'),
      photos: map.getList<String>('photos'),
      lastMatch: map.getSafe<String>('lastMatch'),
      shortDescription: map.getSafe<String>('shortDescription'),
      longDescription: map.getSafe<String>('longDescription'),
      score: map.getSafe<double>('score'),
      price: map.getSafe<double>('price'),
      cityState: cityState,
      typeImmobile: TypeImmobile.get(map.getSafe<String>('typeImmobile')),
      cep: map.getSafe<String>('cep'),
      bathrooms: map.getSafe<int>('bathrooms'),
      bedrooms: map.getSafe<int>('bedrooms'),
      carSpaces: map.getSafe<int>('carSpaces'),
      isMarketNear: map.getSafe<bool>('isMarketNear'),
      isSchoolNear: map.getSafe<bool>('isSchoolNear'),
      isHospitalNear: map.getSafe<bool>('isHospitalNear'),
      isParkNear: map.getSafe<bool>('isParkNear'),
      isGymNear: map.getSafe<bool>('isGymNear'),
      isMallNear: map.getSafe<bool>('isMallNear'),
      isBeachNear: map.getSafe<bool>('isBeachNear'),
    );
  }

  @override
  String toJson() {
    return jsonEncode(toMap());
  }

  factory ImmobileCustomerModel.fromJson(String jsonString) {
    final json = jsonDecode(jsonString);
    return ImmobileCustomerModel.fromMap(json);
  }

  ImmobileCustomerModel copyWith({
    String? id,
    String? email,
    String? password,
    String? phone,
    List<String>? photos,
    String? lastMatch,
    String? shortDescription,
    String? longDescription,
    double? score,
    double? price,
    String? cityState,
    TypeImmobile? typeImmobile,
    String? cep,
    int? bathrooms,
    int? bedrooms,
    int? carSpaces,
    bool? isMarketNear,
    bool? isSchoolNear,
    bool? isHospitalNear,
    bool? isParkNear,
    bool? isGymNear,
    bool? isMallNear,
    bool? isBeachNear,
  }) {
    return ImmobileCustomerModel(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      photos: photos ?? this.photos,
      lastMatch: lastMatch ?? this.lastMatch,
      shortDescription: shortDescription ?? this.shortDescription,
      longDescription: longDescription ?? this.longDescription,
      score: score ?? this.score,
      price: price ?? this.price,
      cityState: cityState ?? this.cityState,
      typeImmobile: typeImmobile ?? this.typeImmobile,
      cep: cep ?? this.cep,
      bathrooms: bathrooms ?? this.bathrooms,
      bedrooms: bedrooms ?? this.bedrooms,
      carSpaces: carSpaces ?? this.carSpaces,
      isMarketNear: isMarketNear ?? this.isMarketNear,
      isSchoolNear: isSchoolNear ?? this.isSchoolNear,
      isHospitalNear: isHospitalNear ?? this.isHospitalNear,
      isParkNear: isParkNear ?? this.isParkNear,
      isGymNear: isGymNear ?? this.isGymNear,
      isMallNear: isMallNear ?? this.isMallNear,
      isBeachNear: isBeachNear ?? this.isBeachNear,
    );
  }
}
