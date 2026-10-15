import 'package:material_ui/material_ui.dart';

import '../../domain/enums/ticket_reaction.dart';

class TicketReactionButtons extends StatelessWidget {
  const TicketReactionButtons({
    super.key,
    required this.userReaction,
    required this.onLike,
    required this.onDislike,
    this.iconSize = 22,
  });

  final TicketReaction? userReaction;
  final VoidCallback onLike;
  final VoidCallback onDislike;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ReactionIconButton(
          icon: Icons.thumb_up_outlined,
          selectedIcon: Icons.thumb_up,
          selected: userReaction == TicketReaction.like,
          color: const Color(0xFF2E7D32),
          iconSize: iconSize,
          onPressed: onLike,
        ),
        const SizedBox(width: 4),
        _ReactionIconButton(
          icon: Icons.thumb_down_outlined,
          selectedIcon: Icons.thumb_down,
          selected: userReaction == TicketReaction.dislike,
          color: const Color(0xFFC62828),
          iconSize: iconSize,
          onPressed: onDislike,
        ),
      ],
    );
  }
}

class _ReactionIconButton extends StatelessWidget {
  const _ReactionIconButton({
    required this.icon,
    required this.selectedIcon,
    required this.selected,
    required this.color,
    required this.iconSize,
    required this.onPressed,
  });

  final IconData icon;
  final IconData selectedIcon;
  final bool selected;
  final Color color;
  final double iconSize;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
      onPressed: onPressed,
      icon: Icon(
        selected ? selectedIcon : icon,
        size: iconSize,
        color: selected ? color : Colors.black45,
      ),
      tooltip: selected ? null : '',
    );
  }
}
