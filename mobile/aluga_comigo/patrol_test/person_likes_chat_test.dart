import 'package:aluga_comigo/app/app_bootstrap.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

import 'support/person_journey_flow.dart';
import 'support/person_journey_test_data.dart';

/// E2E: login → likes pessoa/imóvel → chat imóvel → mensagem de interesse.
void main() {
  patrolTest(
    'login pessoa: likes e mensagem no chat de imóvel',
    ($) async {
      await bootstrapAlugaComigoApp();

      await pumpBrief($, duration: const Duration(seconds: 3));
      await bootstrapLoggedInPersonAccount($);

      await likePersonAndImmobile($);
      await sendRentalInquiryInChats($, PersonJourneyTestData.chatMessage);

      expect(find.textContaining('interesse em alugar'), findsWidgets);
    },
    timeout: Timeout(const Duration(minutes: 12)),
  );
}
