import 'package:aluga_comigo/app/modules/customer/domain/enums/match_type.dart';
import 'package:aluga_comigo/app/modules/like/data/models/incoming_like_model.dart';
import 'package:aluga_comigo/app/modules/like/ui/controllers/likes_controller.dart';
import 'package:aluga_comigo/app/modules/like/ui/widgets/incoming_like_flip_dialog.dart';
import 'package:aluga_comigo/app/shared/data/services/session_service.dart';
import 'package:aluga_comigo/app/shared/presenter/helpers/power_up_prompt_helper.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

import '../widgets/incoming_likes_grid.dart';

class LikesPage extends StatefulWidget {
  const LikesPage({super.key});

  @override
  State<LikesPage> createState() => _LikesPageState();
}

class _LikesPageState extends State<LikesPage> {
  late final ILikesController controller;

  @override
  void initState() {
    super.initState();
    controller = inject<ILikesController>();
    controller.initialize();
  }

  bool _hasActivePowerUp() =>
      SessionService.customer?.hasActivePowerUp ?? false;

  /// Curtidas comuns exigem PowerUp; Super Star sempre liberado.
  bool _shouldBlurItem(IncomingLikeModel item) {
    if (item.matchType == MatchType.favorite) return false;
    return !_hasActivePowerUp();
  }

  bool _canOpenDetails(IncomingLikeModel item) => !_shouldBlurItem(item);

  Future<void> _onItemTap(IncomingLikeModel item) async {
    // if (!IncompleteProfileHelper.isProfileComplete(SessionService.customer)) {
    //   await IncompleteProfileHelper.canShowDetails(context);
    //   return;
    // }
    // if (!mounted) return;

    if (!_canOpenDetails(item)) {
      await PowerUpPromptHelper.promptForIncomingLikes(context);
      if (mounted) setState(() {});
      return;
    }

    await IncomingLikeFlipDialog.show(
      context,
      item: item,
      onRespond: (matchType) => controller.respondToLike(item, matchType),
    );
  }

  Widget _expansionSection({
    required String title,
    required List<IncomingLikeModel> items,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.white24,
            blurRadius: 40,
            offset: Offset(-20, -20),
          ),
          BoxShadow(
            color: Colors.black26,
            blurRadius: 40,
            offset: Offset(20, 20),
          ),
        ],
      ),
      child: ExpansionTile(
        title: Text(title, style: GoogleFonts.rubik()),
        shape: const Border(),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
        expandedAlignment: Alignment.topLeft,
        children: [
          const Divider(height: 1, thickness: 2),
          const Gap(16),
          Row(
            children: [
              Expanded(
                child: IncomingLikesGrid(
                  items: items,
                  blurForItem: _shouldBlurItem,
                  onItemTap: _onItemTap,
                ),
              ),
            ],
          ),
          const Gap(16),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        if (controller.loadingList.contains('loadLikes')) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty && controller.items.isEmpty) {
          return Center(child: Text(controller.errorMessage));
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              _expansionSection(
                title: 'Super Star(${controller.superStars.length})',
                items: controller.superStars,
              ),
              const Gap(16),
              _expansionSection(
                title: 'Curtidas(${controller.likes.length})',
                items: controller.likes,
              ),
              const Gap(90),
            ],
          ),
        );
      },
    );
  }
}
