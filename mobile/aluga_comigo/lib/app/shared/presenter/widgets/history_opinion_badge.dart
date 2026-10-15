import 'package:aluga_comigo/app/modules/customer/data/models/customer_model.dart';
import 'package:aluga_comigo/app/modules/customer/domain/enums/match_type.dart';
import 'package:aluga_comigo/app/shared/domain/constants/icons_asset.dart';
import 'package:aluga_comigo/app/shared/presenter/helpers/inventory_prompt_helper.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_ui/material_ui.dart';

/// Ícone da interação no histórico (curtiu, super star/chat, dislike).
class HistoryOpinionBadge extends StatelessWidget {
  const HistoryOpinionBadge({
    super.key,
    required this.matchType,
    required this.customer,
    this.iconSize = 28,
    this.padding = const EdgeInsets.all(8),
  });

  final MatchType matchType;
  final CustomerModel customer;
  final double iconSize;
  final EdgeInsets padding;

  static bool usesSuperChatFeedIcon(MatchType type, CustomerModel customer) {
    return InventoryPromptHelper.actionUsesSuperChat(type, customer);
  }

  static String iconAsset(MatchType type, CustomerModel customer) {
    return switch (type) {
      MatchType.like => IconsAsset.like,
      MatchType.favorite =>
        usesSuperChatFeedIcon(type, customer)
            ? IconsAsset.chat
            : IconsAsset.superStar1,
      MatchType.unlike => IconsAsset.unlike,
      MatchType.none => IconsAsset.unlike,
    };
  }

  static Color backgroundColor(MatchType type) {
    return switch (type) {
      MatchType.like => const Color(0xFF2E7D32),
      MatchType.favorite => const Color(0xFFE65100),
      MatchType.unlike => const Color(0xFFC62828),
      MatchType.none => Colors.grey,
    };
  }

  @override
  Widget build(BuildContext context) {
    if (matchType == MatchType.none) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor(matchType).withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: usesSuperChatFeedIcon(matchType, customer)
          ? SvgPicture.asset(
              IconsAsset.chat,
              width: iconSize,
              height: iconSize,
              colorFilter: const ColorFilter.mode(
                Colors.amber,
                BlendMode.srcIn,
              ),
            )
          : Image.asset(
              iconAsset(matchType, customer),
              width: iconSize,
              height: iconSize,
            ),
    );
  }
}
