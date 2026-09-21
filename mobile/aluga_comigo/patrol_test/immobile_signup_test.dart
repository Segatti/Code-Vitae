import 'package:aluga_comigo/app/app_bootstrap.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

import 'support/immobile_journey_flow.dart';
import 'support/immobile_journey_test_data.dart';
import 'support/person_journey_flow.dart';

/// E2E: intro → cadastro conta de imóvel (Alugar minha casa) → home do proprietário.
///
/// Device físico:
///   ./scripts/patrolTestDevice.sh 10.0.0.101:5555 patrol_test/immobile_signup_test.dart
void main() {
  patrolTest(
    'cadastro conta imovel: Alugar minha casa até Meus imoveis',
    ($) async {
      await bootstrapAlugaComigoApp();
      final data = ImmobileJourneyTestData.unique();

      await pumpBrief($, duration: const Duration(seconds: 3));

      await completeIntroSlides($);
      await registerImmobileAccount($, data);
      await ensureLocationPermission($);

      expect(find.text('Meus imóveis para alugar'), findsOneWidget);
    },
    timeout: Timeout(const Duration(minutes: 15)),
  );
}
