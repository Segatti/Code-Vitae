import 'package:aluga_comigo/app/modules/chats/domain/entities/chat.dart';
import 'package:aluga_comigo/app/modules/chats/domain/usecases/get_chat_contact_profile.dart';
import 'package:aluga_comigo/app/modules/chats/domain/usecases/unmatch_chat_contact.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

import '../../data/services/analytics_service.dart';
import '../../domain/analytics/analytics_events.dart';
import '../../domain/enums/user_report_context.dart';
import '../../domain/usecases/block_account.dart';
import '../helpers/user_safety_navigation.dart';
import 'app_message_dialog.dart';

class UserSafetySheet extends StatelessWidget {
  final String reportedAccountId;
  final String displayName;
  final UserReportContext reportContext;
  final Chat? chat;
  final VoidCallback? onBlocked;
  final VoidCallback? onUnmatched;

  const UserSafetySheet({
    super.key,
    required this.reportedAccountId,
    required this.displayName,
    required this.reportContext,
    this.chat,
    this.onBlocked,
    this.onUnmatched,
  });

  static Future<void> show(
    BuildContext context, {
    required String reportedAccountId,
    required String displayName,
    required UserReportContext reportContext,
    Chat? chat,
    VoidCallback? onBlocked,
    VoidCallback? onUnmatched,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => UserSafetySheet(
        reportedAccountId: reportedAccountId,
        displayName: displayName,
        reportContext: reportContext,
        chat: chat,
        onBlocked: onBlocked,
        onUnmatched: onUnmatched,
      ),
    );
  }

  Future<void> _onReport(BuildContext context) async {
    Navigator.of(context).pop();
    await UserSafetyNavigation.openReportTicket(
      context,
      reportedAccountId: reportedAccountId,
      displayName: displayName,
      reportContext: reportContext,
    );
  }

  Future<void> _onUnmatch(BuildContext context) async {
    final chat = this.chat;
    if (chat == null) return;

    Navigator.of(context).pop();

    final confirmed = await showAppConfirmDialog(
      context: context,
      title: 'Desfazer match?',
      message:
          'Você deixará de ser match com este contato e a conversa '
          'será removida da lista.',
      confirmLabel: 'Desfazer match',
    );
    if (confirmed != true || !context.mounted) return;

    final profileResult = await inject<IGetChatContactProfile>()(
      reportedAccountId,
    );
    if (!context.mounted) return;

    final customer = profileResult.fold((c) => c, (_) => null);
    if (customer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível carregar o contato')),
      );
      return;
    }

    final result = await inject<IUnmatchChatContact>()(
      contact: customer,
      chat: chat,
    );
    if (!context.mounted) return;

    result.fold(
      (_) {
        onUnmatched?.call();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Match desfeito')),
        );
      },
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao desfazer match')),
        );
      },
    );
  }

  Future<void> _onBlock(BuildContext context) async {
    final confirmed = await showAppConfirmDialog(
      context: context,
      title: 'Bloquear $displayName?',
      message:
          'Esta pessoa não aparecerá no seu feed e você não poderá '
          'conversar com ela. Você pode desfazer o match separadamente.',
      confirmLabel: 'Bloquear',
    );
    if (confirmed != true || !context.mounted) return;

    final block = inject<IBlockAccount>();
    final result = await block(reportedAccountId);
    if (!context.mounted) return;
    Navigator.of(context).pop();

    result.fold(
      (_) async {
        await inject<IAnalyticsService>().logEvent(
          AnalyticsEvents.userBlocked,
          parameters: {
            AnalyticsParams.reportContext: reportContext.analyticsValue,
          },
        );
        onBlocked?.call();
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$displayName foi bloqueado(a)')),
        );
      },
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.toString())),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              chat != null ? 'Opções' : 'Segurança',
              style: GoogleFonts.rubik(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            if (chat != null)
              ListTile(
                leading: const Icon(
                  Icons.link_off,
                  color: Colors.black54,
                ),
                title: const Text('Desfazer match'),
                subtitle: Text(
                  'Remover match com $displayName',
                  style: GoogleFonts.rubik(fontSize: 12, color: Colors.black54),
                ),
                onTap: () => _onUnmatch(context),
              ),
            ListTile(
              leading: const Icon(Icons.flag_outlined, color: Color(0xFF2C29A3)),
              title: const Text('Denunciar'),
              subtitle: Text(
                'Enviar denúncia à moderação (${reportContext.label})',
                style: GoogleFonts.rubik(fontSize: 12, color: Colors.black54),
              ),
              onTap: () => _onReport(context),
            ),
            ListTile(
              leading: const Icon(Icons.block, color: Colors.redAccent),
              title: const Text('Bloquear'),
              subtitle: Text(
                'Ocultar $displayName do feed e das conversas',
                style: GoogleFonts.rubik(fontSize: 12, color: Colors.black54),
              ),
              onTap: () => _onBlock(context),
            ),
          ],
        ),
      ),
    );
  }
}
