import 'package:flutter_modular/flutter_modular.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';
import 'package:styled_text/styled_text.dart';

import 'app_message_dialog.dart';

/// Aceite obrigatório após login quando há nova versão dos Termos.
class TermsReacceptanceDialog extends StatefulWidget {
  const TermsReacceptanceDialog({
    super.key,
    required this.version,
    required this.onAccept,
    required this.onDecline,
  });

  final String version;
  final Future<void> Function() onAccept;
  final Future<void> Function() onDecline;

  @override
  State<TermsReacceptanceDialog> createState() =>
      _TermsReacceptanceDialogState();
}

class _TermsReacceptanceDialogState extends State<TermsReacceptanceDialog> {
  bool _acceptTerms = false;
  bool _busy = false;

  void _openTermsPage() {
    context.pushNamed('/auth/terms?version=${widget.version}');
  }

  @override
  Widget build(BuildContext context) {
    return AppMessageDialogShell(
      title: 'Termos de uso atualizados',
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StyledText(
            text:
                'Há uma nova versão (<orange>v${widget.version}</orange>) dos '
                'Termos de Uso. Para continuar, leia e aceite.',
            style: GoogleFonts.rubik(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            tags: {
              'orange': StyledTextTag(
                style: const TextStyle(color: Color(0xFFDF924B)),
              ),
            },
          ),
          const Gap(16),
          GestureDetector(
            onTap: _openTermsPage,
            child: Container(
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                border: Border.all(color: const Color(0xFF2C29A3), width: 4),
              ),
              child: Text(
                'Ver Termos de Uso',
                style: GoogleFonts.rubik(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const Gap(8),
          GestureDetector(
            onTap: _busy
                ? null
                : () => setState(() => _acceptTerms = !_acceptTerms),
            child: Row(
              children: [
                Checkbox(
                  value: _acceptTerms,
                  onChanged: _busy
                      ? null
                      : (value) {
                          setState(() => _acceptTerms = value ?? false);
                        },
                ),
                const Expanded(
                  child: Text(
                    'Li e aceito os Termos de Uso na versão indicada.',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        AppMessageDialogShell.dismissButton(
          context,
          label: 'Recusar',
          onPressed: _busy
              ? null
              : () async {
                  setState(() => _busy = true);
                  await widget.onDecline();
                },
        ),
        AppMessageDialogShell.primaryButton(
          context,
          label: 'Aceitar',
          onPressed: !_acceptTerms || _busy
              ? null
              : () async {
                  setState(() => _busy = true);
                  await widget.onAccept();
                },
        ),
      ],
    );
  }
}
