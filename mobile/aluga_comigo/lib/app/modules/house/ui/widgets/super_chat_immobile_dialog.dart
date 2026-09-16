import 'package:aluga_comigo/app/shared/domain/constants/icons_asset.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

class SuperChatImmobileDialog extends StatefulWidget {
  const SuperChatImmobileDialog({super.key});

  static Future<String?> show(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (_) => const SuperChatImmobileDialog(),
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
    return AlertDialog(
      title: Row(
        children: [
          SvgPicture.asset(
            IconsAsset.chat,
            width: 28,
            height: 28,
            colorFilter: .mode(Colors.amber, .srcIn),
          ),
          const Gap(8),
          Expanded(
            child: Text(
              'Super Chat',
              style: GoogleFonts.rubik(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Sua mensagem será destacada no chat. Você poderá ver quando o '
              'anunciante ler. O imóvel será marcado como favorito.',
              style: GoogleFonts.rubik(fontSize: 14, color: Colors.black87),
            ),
            const Gap(16),
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
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () {
            final text = _controller.text.trim();
            if (text.isEmpty) return;
            Navigator.of(context).pop(text);
          },
          child: const Text('Enviar'),
        ),
      ],
    );
  }
}
