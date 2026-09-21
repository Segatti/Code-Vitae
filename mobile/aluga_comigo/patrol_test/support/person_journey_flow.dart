import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

import 'person_journey_test_data.dart';

Future<void> grantMobilePermissions(PatrolIntegrationTester $) async {
  if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
    return;
  }
  if (await $.platform.mobile.isPermissionDialogVisible()) {
    await $.platform.mobile.grantPermissionWhenInUse();
  }
}

/// Evita [pumpAndSettle] — Lottie e splash mantêm frames infinitos.
Future<void> pumpBrief(
  PatrolIntegrationTester $, {
  Duration duration = const Duration(milliseconds: 400),
}) async {
  await $.pump(duration);
}

Future<void> pumpUntilVisible(
  PatrolIntegrationTester $,
  Finder finder, {
  Duration timeout = const Duration(seconds: 60),
}) async {
  final end = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(end)) {
    await dismissMaintenanceDialogIfVisible($);
    await $.pump(const Duration(milliseconds: 250));
    if (finder.evaluate().isNotEmpty) {
      await pumpBrief($);
      return;
    }
  }
  fail('Timeout aguardando widget: $finder');
}

Future<void> pumpUntilAnyVisible(
  PatrolIntegrationTester $,
  List<Finder> finders, {
  Duration timeout = const Duration(seconds: 90),
}) async {
  final end = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(end)) {
    await dismissMaintenanceDialogIfVisible($);
    await $.pump(const Duration(milliseconds: 250));
    for (final finder in finders) {
      if (finder.evaluate().isNotEmpty) {
        await pumpBrief($);
        return;
      }
    }
    if (find.text('Falha no Cadastro').evaluate().isNotEmpty) {
      fail('Cadastro falhou — verifique Supabase/rede no device.');
    }
  }
  fail('Timeout aguardando uma das telas: $finders');
}

Future<void> tapSemantics(PatrolIntegrationTester $, String label) async {
  final finder = find.bySemanticsLabel(label);
  await pumpUntilVisible($, finder);
  await $.tester.tap(finder);
  await pumpBrief($);
}

Future<void> dismissMaintenanceDialogIfVisible(PatrolIntegrationTester $) async {
  if (find.textContaining('manutenção').evaluate().isEmpty) {
    return;
  }
  if (find.text('Recarregar').evaluate().isNotEmpty) {
    await $('Recarregar').tap();
    await pumpBrief($, duration: const Duration(seconds: 1));
  }
}

Future<void> dismissIncompleteProfileDialogIfVisible(
  PatrolIntegrationTester $,
) async {
  if (find.text('Perfil Incompleto').evaluate().isNotEmpty) {
    await $('Cancelar').tap();
    await pumpBrief($);
  }
}

Future<void> completeIntroSlides(PatrolIntegrationTester $) async {
  if (find.text('Quero me cadastrar').evaluate().isNotEmpty) {
    return;
  }

  await pumpUntilVisible($, find.byKey(const ValueKey('intro_next_button')));

  for (var step = 0; step < 3; step++) {
    await $(#intro_next_button).tap();
    await pumpBrief($, duration: const Duration(milliseconds: 600));
  }

  await pumpUntilVisible($, find.text('Quero me cadastrar'));
}

Future<void> ensureLocationPermission(PatrolIntegrationTester $) async {
  if (find.byKey(const ValueKey('location_permission_button')).evaluate().isEmpty) {
    return;
  }
  await $(#location_permission_button).tap();
  await grantMobilePermissions($);
  await pumpUntilAnyVisible($, [
    find.bySemanticsLabel('nav_feed_pessoas'),
    find.bySemanticsLabel('nav_feed_imoveis'),
    find.text('Meus imóveis para alugar'),
  ]);
}

Future<void> registerPersonAccount(
  PatrolIntegrationTester $,
  PersonJourneyTestData data,
) async {
  await pumpUntilVisible($, find.text('Quero me cadastrar'));
  await $('Quero me cadastrar').tap();
  await pumpUntilVisible($, find.text('Encontrar pessoa/casa'));
  await $('Encontrar pessoa/casa').tap();

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

  await pumpUntilVisible($, find.text('Habilidades'));
  await $('Mestre Cuca').tap();
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

  await pumpUntilVisible($, find.text('Uma fotinha básica!'));
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
    find.byKey(const ValueKey('feed_like_button')),
    find.bySemanticsLabel('nav_feed_pessoas'),
  ]);
}

Future<void> likePersonAndImmobile(PatrolIntegrationTester $) async {
  await dismissIncompleteProfileDialogIfVisible($);
  await pumpUntilVisible($, find.byKey(const ValueKey('feed_like_button')));
  await $(#feed_like_button).tap();
  await pumpBrief($, duration: const Duration(seconds: 2));

  await tapSemantics($, 'nav_feed_imoveis');
  await pumpUntilVisible($, find.byKey(const ValueKey('feed_like_button')));
  await $(#feed_like_button).tap();
  await pumpBrief($, duration: const Duration(seconds: 3));
}

Future<void> sendRentalInquiryInChats(PatrolIntegrationTester $, String message) async {
  await tapSemantics($, 'nav_chats');
  await pumpUntilVisible($, find.byKey(const ValueKey('chats_tab_imoveis')));
  await $(#chats_tab_imoveis).tap();
  await pumpBrief($);
  await pumpUntilVisible($, find.byKey(const ValueKey('chats_start_conversation')));
  await dismissIncompleteProfileDialogIfVisible($);
  await $(#chats_start_conversation).scrollTo().tap();
  await pumpUntilAnyVisible($, [
    find.byKey(const ValueKey('contact_list_loading')),
    find.byKey(const ValueKey('contact_list_empty')),
    find.byKey(const ValueKey('contact_list_body')),
    find.byKey(const ValueKey('contact_list_error')),
  ]);

  final contactDeadline = DateTime.now().add(const Duration(seconds: 90));
  while (DateTime.now().isBefore(contactDeadline)) {
    await $.pump(const Duration(milliseconds: 250));
    if (find.byKey(const ValueKey('contact_list_empty')).evaluate().isNotEmpty) {
      fail('Lista de contatos vazia — confira likes/matches no backend.');
    }
    if (find.byKey(const ValueKey('contact_list_error')).evaluate().isNotEmpty) {
      fail('Erro ao carregar contatos.');
    }
    final tiles = find.byWidgetPredicate(
      (widget) =>
          widget.key is ValueKey &&
          widget.key!.toString().contains('contact_list_tile_'),
    );
    if (tiles.evaluate().isNotEmpty) {
      await $.tester.tap(tiles.first);
      break;
    }
    if (find.byKey(const ValueKey('contact_list_body')).evaluate().isNotEmpty) {
      await $.tester.tapAt(const Offset(180, 520));
      await pumpBrief($);
      if (find.byKey(const ValueKey('chat_message_field')).evaluate().isNotEmpty) {
        break;
      }
    }
    if (find.byKey(const ValueKey('contact_list_loading')).evaluate().isNotEmpty) {
      continue;
    }
  }

  await pumpUntilVisible(
    $,
    find.byKey(const ValueKey('chat_message_field')),
    timeout: const Duration(seconds: 120),
  );

  await $(#chat_message_field).enterText(message);
  await $(#chat_send_button).tap();
  await pumpUntilVisible($, find.textContaining('interesse em alugar'));
}

Future<void> _tapStartDrawerToggle(PatrolIntegrationTester $) async {
  final animatedMenu = find.byWidgetPredicate(
    (widget) =>
        widget is AnimatedIcon && widget.icon == AnimatedIcons.menu_close,
  );
  if (animatedMenu.evaluate().isNotEmpty) {
    await $.tester.tap(animatedMenu);
  } else {
    await $.tester.tapAt(const Offset(28, 72));
  }
  await pumpBrief($, duration: const Duration(milliseconds: 900));
}

bool _isProfileScreenVisible() {
  return find.text('Perfil').evaluate().isNotEmpty ||
      find.byKey(const ValueKey('profile_user_form')).evaluate().isNotEmpty;
}

Future<void> openProfileFromDrawer(PatrolIntegrationTester $) async {
  if (find.byKey(const ValueKey('profile_user_form')).evaluate().isNotEmpty) {
    return;
  }

  final shellDeadline = DateTime.now().add(const Duration(seconds: 45));
  while (DateTime.now().isBefore(shellDeadline)) {
    if (_isProfileScreenVisible()) {
      return;
    }
    if (find.byKey(const ValueKey('feed_like_button')).evaluate().isNotEmpty) {
      break;
    }
    if (find.byKey(const ValueKey('chat_message_field')).evaluate().isNotEmpty) {
      await $.native.pressBack();
      await pumpBrief($, duration: const Duration(milliseconds: 800));
      continue;
    }
    await tapSemantics($, 'nav_feed_pessoas');
    await pumpBrief($);
  }

  await dismissIncompleteProfileDialogIfVisible($);
  await pumpUntilVisible(
    $,
    find.byKey(const ValueKey('feed_like_button')),
    timeout: const Duration(seconds: 60),
  );

  final profileKey = find.byKey(const ValueKey('drawer_menu_profile'));
  var opened = false;
  for (var attempt = 0; attempt < 5 && !opened; attempt++) {
    await _tapStartDrawerToggle($);

    if (profileKey.evaluate().isNotEmpty) {
      await $.tester.tap(profileKey, warnIfMissed: false);
      await pumpBrief($);
      opened = _isProfileScreenVisible();
    }

    if (!opened) {
      for (final y in [130.0, 165.0, 200.0, 235.0, 270.0]) {
        await $.tester.tapAt(Offset(40, y));
        await pumpBrief($, duration: const Duration(milliseconds: 450));
        if (_isProfileScreenVisible()) {
          opened = true;
          break;
        }
      }
    }
  }

  if (!opened) {
    fail('Não foi possível abrir o perfil pelo menu lateral.');
  }

  await pumpUntilVisible(
    $,
    find.byKey(const ValueKey('profile_user_form')),
    timeout: const Duration(seconds: 90),
  );
}

Future<void> completeProfileFields(PatrolIntegrationTester $) async {
  await pumpUntilVisible(
    $,
    find.byKey(const ValueKey('profile_user_form')),
    timeout: const Duration(seconds: 90),
  );

  await $(#profile_gender_field).scrollTo().tap();
  await pumpBrief($);
  await $('Mulher').tap();
  await pumpBrief($);

  await $(#profile_birth_date_field).scrollTo().tap();
  await pumpBrief($);
  await pumpUntilVisible($, find.text('Confirmar'));
  await $('Confirmar').tap();
  await pumpBrief($);

  await $(#profile_short_description_field)
      .scrollTo()
      .enterText(PersonJourneyTestData.shortDescription);
  await $(#profile_long_description_field)
      .scrollTo()
      .enterText(PersonJourneyTestData.longDescription);

  await $(#profile_desired_immobile_field).scrollTo().tap();
  await $('Casa ou Apartamento').tap();
  await pumpBrief($);

  await $(#profile_price_max_field).scrollTo().enterText('250000');
  await $.tester.testTextInput.receiveAction(TextInputAction.done);
  await pumpBrief($);

  await $(#profile_lifestyle_field).scrollTo().tap();
  await $('Só fico em casa').tap();
  await pumpBrief($);

  await $(#profile_skills_button).scrollTo().tap();
  await pumpUntilVisible($, find.text('Mestre cuca'));
  await $('Mestre cuca').tap();
  await $('Ninja na vassoura').tap();
  await $(#profile_dialog_save).tap();
  await pumpBrief($);

  await $(#profile_houseworks_button).scrollTo().tap();
  await pumpUntilVisible($, find.text('Cozinhar'));
  await $('Cozinhar').tap();
  await $('Limpar casa').tap();
  await $('Lavar roupas').tap();
  await $(#profile_dialog_save).tap();
  await pumpBrief($);

  await $(#profile_save_button).scrollTo().tap();
  await pumpBrief($, duration: const Duration(seconds: 3));
}
