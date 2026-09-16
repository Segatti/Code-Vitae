import 'package:aluga_comigo/app/shared/domain/constants/icons_asset.dart';
import 'package:material_ui/material_ui.dart';

import '../../interactor/models/store_product.dart';

class StoreProductIconWidget extends StatelessWidget {
  final StoreProductIcon icon;

  const StoreProductIconWidget({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return switch (icon) {
      StoreProductIcon.superStar1 => Image.asset(IconsAsset.superStar1),
      StoreProductIcon.superStar2 => Image.asset(IconsAsset.superStar2),
      StoreProductIcon.superStar3 => Image.asset(IconsAsset.superStar3),
      StoreProductIcon.superChat1 => Image.asset(IconsAsset.superChat1),
      StoreProductIcon.superChat2 => Image.asset(IconsAsset.superChat2),
      StoreProductIcon.superChat3 => Image.asset(IconsAsset.superChat3),
      StoreProductIcon.powerUp1 => _rocket(size: 36),
      StoreProductIcon.powerUp2 => _rocket(size: 44),
      StoreProductIcon.powerUp3 => _rocket(size: 52),
    };
  }

  Widget _rocket({required double size}) {
    return Icon(
      Icons.rocket_launch_rounded,
      size: size,
      color: const Color(0xFFDF924B),
    );
  }
}
