import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

class ChatAttachAction {
  final String id;
  final String label;
  final IconData icon;
  final Color? iconColor;
  final Widget? iconWidget;

  const ChatAttachAction({
    required this.id,
    required this.label,
    required this.icon,
    this.iconColor,
    this.iconWidget,
  });
}

class ChatAttachActionSheet extends StatelessWidget {
  final List<ChatAttachAction> actions;
  final ValueChanged<String> onActionSelected;

  const ChatAttachActionSheet({
    super.key,
    required this.actions,
    required this.onActionSelected,
  });

  static Future<void> show(
    BuildContext context, {
    required List<ChatAttachAction> actions,
    required ValueChanged<String> onActionSelected,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ChatAttachActionSheet(
        actions: actions,
        onActionSelected: (id) {
          Navigator.of(ctx).pop();
          onActionSelected(id);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1F1F1F),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: actions.map((action) {
                return InkWell(
                  onTap: () => onActionSelected(action.id),
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 88,
                    child: Column(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: action.iconWidget ??
                                Icon(
                                  action.icon,
                                  color: action.iconColor ?? Colors.white,
                                  size: 28,
                                ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          action.label,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.rubik(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
