import 'package:aluga_comigo/app/modules/customer/data/models/customer_model.dart';
import 'package:equatable/equatable.dart';

import '../../../auth/domain/enums/type_user.dart';
import '../../../auth/domain/enums/user_desired_immobile.dart';
import '../../../auth/domain/enums/user_life_style.dart';
import '../../../auth/domain/enums/user_skill.dart';

class Customer extends CustomerModel with EquatableMixin {
  Customer({
    super.id,
    super.email,
    super.password,
    super.typeUser,
    super.name,
    super.phone,
    super.skills,
    super.photos,
    super.lastMatch,
    super.dateBirth,
    super.shortDescription,
    super.longDescription,
    super.score,
    super.priceMaxImmobile,
    super.cityState,
    super.desiredImmobile,
    super.lifeStyle,
    super.gender,
  });

  factory Customer.fromModel(CustomerModel model) {
    return Customer(
      id: model.id,
      email: model.email,
      password: model.password,
      typeUser: model.typeUser,
      name: model.name,
      phone: model.phone,
      skills: model.skills,
      photos: model.photos,
      lastMatch: model.lastMatch,
      dateBirth: model.dateBirth,
      shortDescription: model.shortDescription,
      longDescription: model.longDescription,
      score: model.score,
      priceMaxImmobile: model.priceMaxImmobile,
      cityState: model.cityState,
      desiredImmobile: model.desiredImmobile,
      lifeStyle: model.lifeStyle,
      gender: model.gender,
    );
  }

  CustomerModel toModel() {
    return CustomerModel(
      id: id,
      email: email,
      password: password,
      typeUser: typeUser,
      name: name,
      phone: phone,
      skills: skills,
      photos: photos,
      lastMatch: lastMatch,
      dateBirth: dateBirth,
      shortDescription: shortDescription,
      longDescription: longDescription,
      score: score,
      priceMaxImmobile: priceMaxImmobile,
      cityState: cityState,
      desiredImmobile: desiredImmobile,
      lifeStyle: lifeStyle,
      gender: gender,
    );
  }

  @override
  List<Object?> get props => [
    id,
    email,
    password,
    typeUser,
    name,
    phone,
    skills,
    photos,
    lastMatch,
    dateBirth,
    shortDescription,
    longDescription,
    score,
    priceMaxImmobile,
    cityState,
    desiredImmobile,
    lifeStyle,
    gender,
  ];

  @override
  bool? get stringify => true;

  @override
  Customer copyWith({
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
    return Customer(
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
      lifeStyle: lifeStyle ?? this.lifeStyle,
      gender: gender ?? this.gender,
    );
  }
}
