import 'package:aluga_comigo/app/modules/like/data/models/incoming_like_model.dart';
import 'package:aluga_comigo/app/modules/like/ui/controllers/likes_controller.dart';
import 'package:aluga_comigo/app/shared/data/services/session_service.dart';
import 'package:aluga_comigo/app/shared/presenter/helpers/incomplete_profile_helper.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../widgets/incoming_likes_grid.dart';

class LikesPage extends StatefulWidget {
  const LikesPage({super.key});

  @override
  State<LikesPage> createState() => _LikesPageState();
}

class _LikesPageState extends State<LikesPage> {
  final controller = inject<ILikesController>();

  @override
  void initState() {
    super.initState();
    controller.initialize();
  }

  List<String> _photosFromItems(List<IncomingLikeModel> items) {
    return items
        .map((item) => item.customer.photos.isNotEmpty ? item.customer.photos.first : '')
        .where((photo) => photo.isNotEmpty)
        .toList();
  }

  Widget _expansionSection({
    required String title,
    required List<String> photos,
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
        title: Text(title),
        shape: const Border(),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
        expandedAlignment: Alignment.topLeft,
        children: [
          const Divider(height: 1, thickness: 2),
          const Gap(16),
          IncomingLikesGrid(
            photoUrls: photos,
            blurPhotos: blurPhotos,
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

        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage));
        }

        final superStarPhotos = _photosFromItems(controller.superStars);
        final likePhotos = _photosFromItems(controller.likes);

        return SingleChildScrollView(
          child: Column(
            children: [
              _expansionSection(
                title: 'Super Star(${superStarPhotos.length})',
                photos: superStarPhotos,
                blurPhotos: false,
              ),
              const Gap(16),
              _expansionSection(
                title: 'Curtidas(${likePhotos.length})',
                photos: likePhotos,
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
