import 'package:aluga_comigo/app/app_bootstrap.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

import 'support/person_journey_flow.dart' show completeIntroSlides, completeProfileFields, ensureLocationPermission, likePersonAndImmobile, openProfileFromDrawer, pumpBrief, registerPersonAccount, sendRentalInquiryInChats;
import 'support/person_journey_test_data.dart';

/// E2E espelhando a jornada validada manualmente (Marionette):
/// intro (3 telas) → cadastro pessoa → likes → chat → perfil completo.
///
/// O APK do Patrol precisa das mesmas `--dart-define` do `flutter run`
/// (senão Supabase/API ficam nos placeholders e a splash mostra “manutenção”).
///
/// Celular físico (10.0.0.x na mesma Wi-Fi):
///   chmod +x scripts/patrolTestDevice.sh
///   ./scripts/patrolTestDevice.sh 10.0.0.101:5555
///
/// Emulador Android:
///   patrol test --dart-define-from-file=dart_defines.android.json \\
///     -t patrol_test/person_complete_journey_test.dart
void main() {
  patrolTest(
    'jornada pessoa: cadastro, likes, chat e perfil',
    ($) async {
      await bootstrapAlugaComigoApp();
      final data = PersonJourneyTestData.unique();

      await pumpBrief($, duration: const Duration(seconds: 3));

      await completeIntroSlides($);
      await registerPersonAccount($, data);
      await ensureLocationPermission($);

      await likePersonAndImmobile($);
      await sendRentalInquiryInChats($, PersonJourneyTestData.chatMessage);
      await openProfileFromDrawer($);
      await completeProfileFields($);

      expect(find.text('Perfil'), findsOneWidget);
    },
    timeout: Timeout(const Duration(minutes: 15)),
  );
}
