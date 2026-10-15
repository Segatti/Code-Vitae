import 'package:aluga_comigo/app/modules/customer/data/models/customer_model.dart';
import 'package:aluga_comigo/app/modules/customer/domain/enums/match_type.dart';
import 'package:aluga_comigo/app/shared/domain/constants/icons_asset.dart';
import 'package:aluga_comigo/app/shared/presenter/helpers/inventory_prompt_helper.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_ui/material_ui.dart';

/// Ícone do botão central do feed (Super Star ou Super Chat), reutilizado no histórico.
class FeedSuperStarActionIcon extends StatelessWidget {
  const FeedSuperStarActionIcon({
    super.key,
    required this.target,
    this.size = 45,
  });

  final CustomerModel target;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (InventoryPromptHelper.actionUsesSuperChat(
      MatchType.favorite,
      target,
    )) {
      return SvgPicture.asset(
        IconsAsset.chat,
        width: size,
        height: size,
        colorFilter: const ColorFilter.mode(
          Colors.amber,
          BlendMode.srcIn,
        ),
      );
    }

    return Image.asset(
      IconsAsset.favorite,
      width: size,
      height: size,
    );
  }
}
