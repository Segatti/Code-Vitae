import 'package:aluga_comigo/app/modules/customer/domain/enums/match_type.dart';
import 'package:aluga_comigo/app/modules/like/data/models/incoming_like_model.dart';
import 'package:aluga_comigo/app/modules/like/ui/controllers/likes_controller.dart';
import 'package:aluga_comigo/app/shared/data/services/session_service.dart';
import 'package:aluga_comigo/app/shared/presenter/helpers/incomplete_profile_helper.dart';
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

  Future<void> _onItemTap(IncomingLikeModel item) async {
    if (!IncompleteProfileHelper.isProfileComplete(SessionService.customer)) {
      await IncompleteProfileHelper.canShowDetails(context);
      return;
    }

    final action = await showModalBottomSheet<MatchType>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.favorite, color: Colors.blue),
              title: const Text('Curtir de volta'),
              onTap: () => Navigator.of(context).pop(MatchType.like),
            ),
            ListTile(
              leading: const Icon(Icons.star, color: Colors.amber),
              title: const Text('Super Star'),
              onTap: () => Navigator.of(context).pop(MatchType.favorite),
            ),
            ListTile(
              leading: const Icon(Icons.close, color: Colors.red),
              title: const Text('Rejeitar'),
              onTap: () => Navigator.of(context).pop(MatchType.unlike),
            ),
          ],
        ),
      ),
    );

    if (action == null || !mounted) return;

    final success = await controller.respondToLike(item, action);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Resposta enviada!'
              : controller.errorMessage.isNotEmpty
                  ? controller.errorMessage
                  : 'Erro ao responder',
        ),
      ),
    );
  }

  Widget _expansionSection({
    required String title,
    required List<IncomingLikeModel> items,
    required bool blurPhotos,
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
          IncomingLikesGrid(
            items: items,
            blurPhotos: blurPhotos,
            onItemTap: blurPhotos ? null : _onItemTap,
          ),
          const Gap(16),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileComplete = IncompleteProfileHelper.isProfileComplete(
      SessionService.customer,
    );

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
                blurPhotos: false,
              ),
              const Gap(16),
              _expansionSection(
                title: 'Curtidas(${controller.likes.length})',
                items: controller.likes,
                blurPhotos: !profileComplete,
              ),
              const Gap(90),
            ],
          ),
        );
      },
    );
  }
}
