import 'package:aluga_comigo/app/app_bootstrap.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

import 'support/person_journey_flow.dart';

/// E2E: login → perfil → preencher campos → salvar.
///
/// Sem `PATROL_PERSON_EMAIL` no dart-define: cadastra conta, desloga e loga de novo.
void main() {
  patrolTest(
    'login pessoa: editar perfil e salvar',
    ($) async {
      await bootstrapAlugaComigoApp();

      await pumpBrief($, duration: const Duration(seconds: 3));
      await bootstrapLoggedInPersonAccount($);

      await openProfileFromDrawer($);
      await completeProfileFields($);

      expect(find.text('Perfil'), findsOneWidget);
    },
    timeout: Timeout(const Duration(minutes: 12)),
  );
}
