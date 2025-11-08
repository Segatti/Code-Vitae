import 'dart:convert';

import 'package:aluga_comigo/app/shared/domain/extends/map_convert.dart';

import '../../../auth/domain/enums/type_user.dart';
import '../../../auth/domain/enums/user_desired_immobile.dart';
import '../../../auth/domain/enums/user_life_style.dart';
import '../../../auth/domain/enums/user_skill.dart';

class CustomerModel {
  final String id;
  final String email;
  final String password;
  final TypeUser typeUser;
  final String name;
  final String phone;
  final List<UserSkill> skills;
  final List<String> photos;
  final String lastMatch;
  final String dateBirth;
  final String shortDescription;
  final String longDescription;
  final double score;
  final double priceMaxImmobile;
  final String cityState;
  final UserDesiredImmobile desiredImmobile;
  final UserLifeStyle lifeStyle;
  final String gender;

  CustomerModel({
    this.id = "",
    this.email = "",
    this.password = "",
    this.typeUser = TypeUser.none,
    this.name = "",
    this.phone = "",
    this.skills = const [],
    this.photos = const [],
    this.lastMatch = "",
    this.dateBirth = "",
    this.shortDescription = "",
    this.longDescription = "",
    this.score = 0,
    this.priceMaxImmobile = 0,
    this.cityState = "",
    this.desiredImmobile = UserDesiredImmobile.none,
    this.lifeStyle = UserLifeStyle.none,
    this.gender = "",
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
      'name': name,
      'phone': phone,
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

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    var city = map.getSafe<String>('city');
    var state = map.getSafe<String>('state');
    var cityState = '$city - $state';
    return CustomerModel(
      id: map.getSafe<String>('id'),
      email: map.getSafe<String>('email'),
      password: map.getSafe<String>('password'),
      typeUser: TypeUser.get(map.getSafe<String>('typeUser')),
      name: map.getSafe<String>('name'),
      phone: map.getSafe<String>('phone'),
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

  String toJson() {
    return jsonEncode(toMap());
  }

  factory CustomerModel.fromJson(String jsonString) {
    final json = jsonDecode(jsonString);
    return CustomerModel.fromMap(json);
  }

  CustomerModel copyWith({
    String? id,
    String? email,
    String? password,
    TypeUser? typeUser,
    String? name,
    String? phone,
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
    return CustomerModel(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      typeUser: typeUser ?? this.typeUser,
      name: name ?? this.name,
      phone: phone ?? this.phone,
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
