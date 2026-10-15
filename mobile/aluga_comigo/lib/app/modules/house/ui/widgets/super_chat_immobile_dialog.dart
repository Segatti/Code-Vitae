import 'package:aluga_comigo/app/shared/domain/constants/icons_asset.dart';
import 'package:aluga_comigo/app/shared/presenter/widgets/app_message_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

class SuperChatImmobileDialog extends StatefulWidget {
  const SuperChatImmobileDialog({this.inConversation = false, super.key});

  final bool inConversation;

  static Future<String?> show(
    BuildContext context, {
    bool inConversation = false,
  }) {
    return showDialog<String>(
      context: context,
      builder: (_) => SuperChatImmobileDialog(inConversation: inConversation),
    );
  }

  @override
  State<SuperChatImmobileDialog> createState() =>
      _SuperChatImmobileDialogState();
}

class _SuperChatImmobileDialogState extends State<SuperChatImmobileDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppMessageDialogShell(
      title: 'Super Chat',
      message: widget.inConversation
          ? 'Sua mensagem será destacada no chat. Você poderá ver quando o '
              'destinatário ler.'
          : 'Sua mensagem será destacada no chat. Você poderá ver quando o '
              'anunciante ler. O imóvel será marcado como favorito.',
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                IconsAsset.chat,
                width: 28,
                height: 28,
                colorFilter: .mode(Colors.amber, .srcIn),
              ),
              const Gap(8),
              Text(
                'Mensagem',
                style: GoogleFonts.rubik(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const Gap(8),
          TextField(
            controller: _controller,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Escreva sua mensagem...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
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
          label: 'Enviar',
          onPressed: () {
            final text = _controller.text.trim();
            if (text.isEmpty) return;
            Navigator.of(context).pop(text);
          },
        ),
      ],
    );
  }
}
