import 'package:aluga_comigo/app/app_bootstrap.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

import 'support/person_journey_flow.dart';
import 'support/person_journey_test_data.dart';

/// E2E: intro → cadastro pessoa (Encontrar pessoa/casa) → home com menus de pessoa.
void main() {
  patrolTest(
    'cadastro conta pessoa: Encontrar pessoa ou casa até home',
    ($) async {
      await bootstrapAlugaComigoApp();
      final data = PersonJourneyTestData.unique();

      await pumpBrief($, duration: const Duration(seconds: 3));
      await completeIntroSlides($);
      await registerPersonAccount($, data);
      await ensureLocationPermission($);

      await expectPersonAccountHomeShell($);
    },
    timeout: Timeout(const Duration(minutes: 15)),
  );
}
