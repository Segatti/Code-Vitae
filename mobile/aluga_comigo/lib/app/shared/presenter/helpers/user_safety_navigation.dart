import 'dart:async';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:material_ui/material_ui.dart';

import '../../data/services/analytics_service.dart';
import '../../domain/analytics/analytics_events.dart';
import '../../domain/enums/user_report_context.dart';

class UserSafetyNavigation {
  UserSafetyNavigation._();

  static Future<void> openReportTicket(
    BuildContext context, {
    required String reportedAccountId,
    required String displayName,
    required UserReportContext reportContext,
  }) async {
    unawaited(
      inject<IAnalyticsService>().logEvent(
        AnalyticsEvents.reportStarted,
        parameters: {
          AnalyticsParams.reportContext: reportContext.analyticsValue,
        },
      ),
    );

    if (!context.mounted) return;
    await context.pushNamed(
      '/tickets/new',
      arguments: {
        'category': 'report',
        'title': 'Denúncia — $displayName',
        'description':
            'Contexto: ${reportContext.label}\n'
            'Conta denunciada (ID): $reportedAccountId\n\n'
            'Descreva o ocorrido com o máximo de detalhes possível.',
        'reportedAccountId': reportedAccountId,
        'reportContext': reportContext.storageValue,
      },
    );
  }
}
