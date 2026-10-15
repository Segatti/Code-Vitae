import 'package:aluga_comigo/app/shared/presenter/widgets/app_message_dialog.dart';
import 'package:gap/gap.dart';
import 'package:styled_text/styled_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

/// Termos de uso no fim do cadastro (pessoa ou imóvel).
class SignupTermsDialog extends StatefulWidget {
  const SignupTermsDialog({super.key, required this.onConfirm});

  final Future<void> Function() onConfirm;

  static Future<void> show(
    BuildContext context, {
    required Future<void> Function() onConfirm,
  }) {
    return showDialog<void>(
      context: context,
      builder: (_) => SignupTermsDialog(onConfirm: onConfirm),
    );
  }

  @override
  State<SignupTermsDialog> createState() => _SignupTermsDialogState();
}

class _SignupTermsDialogState extends State<SignupTermsDialog> {
  bool _acceptTerms = false;

  @override
  Widget build(BuildContext context) {
    return AppMessageDialogShell(
      title: 'Termos de uso',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StyledText(
            text:
                'Ao confirmar você está aceitando os '
                '<orange>termos de uso do app</orange>!',
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
            onTap: () {
              launchUrl(
                Uri.parse(
                  'https://drive.google.com/file/d/1Ob1x0-bLgEiZs7RYAqF7NfY2sNR51rBc/view?usp=drive_link',
                ),
                mode: LaunchMode.externalApplication,
              );
            },
            child: Container(
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                border: Border.all(color: const Color(0xFF2C29A3), width: 4),
              ),
              child: Text(
                'Leia aqui os Termos de Uso',
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
            onTap: () => setState(() => _acceptTerms = !_acceptTerms),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  key: const ValueKey('signup_terms_checkbox'),
                  visualDensity: VisualDensity.compact,
                  value: _acceptTerms,
                  onChanged: (value) {
                    setState(() => _acceptTerms = value ?? false);
                  },
                ),
                const Flexible(
                  child: Text('Declaro que tenho 18 anos ou mais.'),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        AppMessageDialogShell.dismissButton(
          context,
          onPressed: () => Navigator.of(context).pop(),
        ),
        AppMessageDialogShell.primaryButton(
          context,
          key: const ValueKey('signup_terms_confirm'),
          label: 'Confirmar',
          onPressed: _acceptTerms
              ? () async {
                  Navigator.of(context).pop();
                  await widget.onConfirm();
                }
              : null,
        ),
      ],
    );
  }
}
