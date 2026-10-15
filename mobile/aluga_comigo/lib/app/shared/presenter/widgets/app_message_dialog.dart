import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

/// Diálogo padrão do app: título com traço laranja, mensagem e ações
/// (mesmo padrão do logout no drawer).
class AppMessageDialogShell extends StatelessWidget {
  const AppMessageDialogShell({
    super.key,
    required this.title,
    this.message,
    this.body,
    this.messageAlign = TextAlign.start,
    required this.actions,
  });

  final String title;
  final String? message;
  final Widget? body;
  final TextAlign messageAlign;
  final List<Widget> actions;

  static const _accentOrange = Color(0xFFDF924B);
  static const _accentBlue = Color(0xFF2C29A3);

  @override
  Widget build(BuildContext context) {
    final maxBodyHeight = MediaQuery.sizeOf(context).height * 0.45;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: DefaultTextStyle(
        style: const TextStyle(
          decoration: TextDecoration.none,
          color: Colors.black,
        ),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: _accentOrange, width: 5),
                    ),
                  ),
                  child: Text(
                    title,
                    style: GoogleFonts.rubik(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Gap(16),
                if (message != null && message!.isNotEmpty)
                  Text(
                    message!,
                    textAlign: messageAlign,
                    style: GoogleFonts.rubik(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                if (body != null) ...[
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: maxBodyHeight),
                    child: body!,
                  ),
                  const Gap(16),
                ] else if (message != null && message!.isNotEmpty)
                  const Gap(16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: actions,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget dismissButton(
    BuildContext context, {
    String label = 'Cancelar',
    VoidCallback? onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: _accentOrange,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: onPressed ?? () => Navigator.of(context).pop(false),
      child: Text(
        label,
        style: GoogleFonts.rubik(fontSize: 16, color: Colors.white),
      ),
    );
  }

  static Widget primaryButton(
    BuildContext context, {
    required String label,
    Key? key,
    bool destructive = false,
    VoidCallback? onPressed,
  }) {
    final borderColor = destructive ? Colors.red : _accentBlue;
    return ElevatedButton(
      key: key,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: BorderSide(color: borderColor, width: 5),
      ),
      onPressed: onPressed ?? () => Navigator.of(context).pop(true),
      child: Text(
        label,
        style: GoogleFonts.rubik(fontSize: 16, color: Colors.black),
      ),
    );
  }
}

Future<bool?> showAppConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  String cancelLabel = 'Cancelar',
  String confirmLabel = 'Confirmar',
  bool barrierDismissible = true,
  bool confirmDestructive = false,
  Key? confirmKey,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (dialogContext) => AppMessageDialogShell(
      title: title,
      message: message,
      actions: [
        AppMessageDialogShell.dismissButton(
          dialogContext,
          label: cancelLabel,
          onPressed: () => Navigator.of(dialogContext).pop(false),
        ),
        AppMessageDialogShell.primaryButton(
          dialogContext,
          key: confirmKey,
          label: confirmLabel,
          destructive: confirmDestructive,
          onPressed: () => Navigator.of(dialogContext).pop(true),
        ),
      ],
    ),
  );
}

Future<void> showAppAckDialog({
  required BuildContext context,
  required String title,
  required String message,
  String okLabel = 'OK',
  bool barrierDismissible = false,
  VoidCallback? onAck,
  TextAlign messageAlign = TextAlign.start,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (dialogContext) => AppMessageDialogShell(
      title: title,
      message: message,
      messageAlign: messageAlign,
      actions: [
        AppMessageDialogShell.dismissButton(
          dialogContext,
          label: okLabel,
          onPressed: () {
            Navigator.of(dialogContext).pop();
            onAck?.call();
          },
        ),
      ],
    ),
  );
}
