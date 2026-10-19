import 'package:aluga_comigo/app/shared/domain/constants/icons_asset.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_ui/material_ui.dart';

import '../../interactor/models/store_product.dart';

class StoreProductIconWidget extends StatelessWidget {
  final StoreProductIcon icon;

  const StoreProductIconWidget({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return switch (icon) {
      StoreProductIcon.superStar1 => SvgPicture.asset(IconsAsset.superStar1),
      StoreProductIcon.superStar2 => SvgPicture.asset(IconsAsset.superStar2),
      StoreProductIcon.superStar3 => SvgPicture.asset(IconsAsset.superStar3),
      StoreProductIcon.superChat1 => SvgPicture.asset(IconsAsset.superChat1),
      StoreProductIcon.superChat2 => SvgPicture.asset(IconsAsset.superChat2),
      StoreProductIcon.superChat3 => SvgPicture.asset(IconsAsset.superChat3),
      StoreProductIcon.powerUp1 => SvgPicture.asset(IconsAsset.powerup1),
      StoreProductIcon.powerUp2 => SvgPicture.asset(IconsAsset.powerup2),
      StoreProductIcon.powerUp3 => SvgPicture.asset(IconsAsset.powerup3),
    };
  }
}
