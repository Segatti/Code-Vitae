import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

import 'immobile_journey_test_data.dart';
import 'person_journey_flow.dart';

Future<void> registerImmobileAccount(
  PatrolIntegrationTester $,
  ImmobileJourneyTestData data,
) async {
  await pumpUntilVisible($, find.text('Quero me cadastrar'));
  await $('Quero me cadastrar').tap();
  await pumpUntilVisible($, find.text('Alugar minha casa'));
  await $('Alugar minha casa').tap();

  await pumpUntilVisible($, find.text('Dados de acesso'));
  await pumpUntilVisible($, find.byKey(const ValueKey('signup_email_field')));
  await $(#signup_email_field).enterText(data.email);
  await $(#signup_password_field).enterText(data.password);
  await $('Confirmar').tap();

  await pumpUntilVisible($, find.text('Dados pessoais'));
  await pumpUntilVisible($, find.byKey(const ValueKey('signup_name_field')));
  await $(#signup_name_field).enterText(data.name);
  await $(#signup_phone_field).enterText(data.phone);
  await $('Confirmar').tap();

  await pumpUntilVisible($, find.text('Dados do Imóvel'));
  await $(#signup_immobile_value_field).enterText(ImmobileJourneyTestData.rentValue);
  await $(#signup_immobile_cep_field).enterText(ImmobileJourneyTestData.cep);
  await $(#signup_immobile_type_dropdown).tap();
  await pumpBrief($);
  await $('Casa').tap();
  await $('Confirmar').tap();

  await pumpUntilVisible($, find.text('Endereço'));
  await pumpUntilVisible($, find.byKey(const ValueKey('signup_state_dropdown')));
  await $(#signup_state_dropdown).tap();
  await pumpBrief($);
  await $('AC - Acre').scrollTo().tap();
  await pumpUntilVisible($, find.byKey(const ValueKey('signup_city_dropdown')));
  await $(#signup_city_dropdown).tap();
  await pumpBrief($);
  await $('Acrelândia').scrollTo().tap();
  await $('Confirmar').tap();

  await pumpUntilVisible($, find.text('Uma fotinha do imóvel!'));
  await $(Icons.camera_alt).tap();
  await grantMobilePermissions($);
  await pumpUntilVisible($, find.byKey(const ValueKey('camera_shutter_button')));
  await $(#camera_shutter_button).tap();
  await pumpBrief($, duration: const Duration(seconds: 1));
  await pumpUntilVisible($, find.byKey(const ValueKey('signup_photo_confirm')));
  await $(#signup_photo_confirm).tap();

  await pumpUntilVisible($, find.textContaining('Declaro que tenho 18 anos'));
  await $(#signup_terms_checkbox).tap();
  await $(#signup_terms_confirm).tap();

  await pumpUntilAnyVisible($, [
    find.byKey(const ValueKey('location_permission_button')),
    find.text('Meus imóveis para alugar'),
    find.bySemanticsLabel('nav_feed_imoveis'),
  ]);
}
