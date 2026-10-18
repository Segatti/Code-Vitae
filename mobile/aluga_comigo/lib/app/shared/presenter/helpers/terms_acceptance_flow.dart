import 'package:flutter_modular/flutter_modular.dart';
import 'package:material_ui/material_ui.dart';

import '../../data/services/secure_storage_service.dart';
import '../../data/services/session_service.dart';
import '../../data/services/supabase_auth_service.dart';
import '../../domain/usecases/check_terms_acceptance_required.dart';
import '../../domain/usecases/record_terms_acceptance.dart';
import 'feed_session_helper.dart';
import '../widgets/terms_reacceptance_dialog.dart';

/// Bloqueia o uso do app até aceitar a versão vigente dos Termos de Uso.
abstract final class TermsAcceptanceFlow {
  static Future<bool> ensureAcceptedIfNeeded(BuildContext context) async {
    final accountId = SessionService.customer?.id;
    if (accountId == null || accountId.isEmpty) return true;

    final currentVersion =
        SessionService.systemConfig.termsOfUseCurrentVersion;
    final check = inject<ICheckTermsAcceptanceRequired>();
    final requiredResult = await check(
      accountId: accountId,
      currentVersion: currentVersion,
    );

    final needsAcceptance = requiredResult.fold(
      (_) => false,
      (required) => required,
    );
    if (!needsAcceptance) return true;
    if (!context.mounted) return false;

    return _showReacceptanceDialog(context, currentVersion);
  }

  static Future<bool> _showReacceptanceDialog(
    BuildContext context,
    String version,
  ) async {
    final accepted = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return PopScope(
          canPop: false,
          child: TermsReacceptanceDialog(
            version: version,
            onAccept: () async {
              final record = inject<IRecordTermsAcceptance>();
              final result = await record(version);
              if (!dialogContext.mounted) return;
              result.fold(
                (_) => Navigator.of(dialogContext).pop(false),
                (_) => Navigator.of(dialogContext).pop(true),
              );
            },
            onDecline: () async {
              await _logout();
              if (dialogContext.mounted) {
                Navigator.of(dialogContext).pop(false);
              }
            },
          ),
        );
      },
    );
    return accepted ?? false;
  }

  static Future<void> _logout() async {
    final auth = inject<SupabaseAuthService>();
    final storage = inject<SecureStorageService>();
    await auth.signOut();
    await storage.deleteData(StorageKey.user);
    FeedSessionHelper.resetSessionScopedControllers();
    SessionService.clearCustomer();
  }
}
