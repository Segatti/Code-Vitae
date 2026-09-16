import 'dart:io';

import 'package:aluga_comigo/app/modules/config/ui/controllers/profile_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

/// Faixa de fotos do perfil: adicionar, reordenar (arrastar) e remover.
class ProfilePhotosEditor extends StatelessWidget {
  const ProfilePhotosEditor({
    super.key,
    required this.controller,
  });

  final IProfileController controller;

  static const _tileWidth = 115.0;
  static const _tileHeight = 155.0;

  int get _savedCount => controller.customer?.photos.length ?? 0;

  int get _totalCount => _savedCount + controller.selectedPhotos.length;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_totalCount > 1)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Arraste as fotos para reordenar. A primeira é a capa do card.',
              style: GoogleFonts.rubik(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
          ),
        if (_totalCount > 1) const Gap(8),
        SizedBox(
          height: _tileHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(16),
              if (controller.canAddMorePhotos) ...[
                _AddPhotoTile(onTap: controller.selectPhotos),
                const Gap(16),
              ],
              Expanded(
                child: _totalCount == 0
                    ? const SizedBox.shrink()
                    : ReorderableListView.builder(
                        scrollDirection: Axis.horizontal,
                        buildDefaultDragHandles: false,
                        onReorderItem: controller.reorderPhotos,
                        itemCount: _totalCount,
                        itemBuilder: (context, index) {
                          final isSaved = index < _savedCount;
                          return Padding(
                            key: ValueKey(
                              isSaved
                                  ? 'saved-${controller.customer!.photos[index]}'
                                  : 'pending-${controller.selectedPhotos[index - _savedCount].path}',
                            ),
                            padding: const EdgeInsets.only(right: 16),
                            child: ReorderableDragStartListener(
                              index: index,
                              child: _PhotoTile(
                                onRemove: () {
                                  if (isSaved) {
                                    controller.removePhoto(index);
                                  } else {
                                    controller.removeSelectedPhoto(
                                      index - _savedCount,
                                    );
                                  }
                                },
                                child: isSaved
                                    ? CachedNetworkImage(
                                        imageUrl:
                                            controller.customer!.photos[index],
                                        width: _tileWidth,
                                        height: _tileHeight,
                                        fit: BoxFit.cover,
                                        errorWidget: (_, _, _) =>
                                            const SizedBox.shrink(),
                                      )
                                    : Image.file(
                                        File(
                                          controller
                                              .selectedPhotos[index -
                                                  _savedCount]
                                              .path,
                                        ),
                                        width: _tileWidth,
                                        height: _tileHeight,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, _, _) =>
                                            const SizedBox.shrink(),
                                      ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AddPhotoTile extends StatelessWidget {
  const _AddPhotoTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: ProfilePhotosEditor._tileHeight,
        width: ProfilePhotosEditor._tileWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.white24,
              offset: Offset(-5, -5),
              blurRadius: 20,
            ),
            BoxShadow(
              color: Colors.black26,
              offset: Offset(5, 5),
              blurRadius: 20,
            ),
          ],
          color: Colors.white,
        ),
        child: Center(
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFD9D9D9),
            ),
            padding: const EdgeInsets.all(8),
            child: const Icon(
              Icons.add,
              color: Color(0xFF7C7C7C),
            ),
          ),
        ),
      ),
    );
  }
}

class _PhotoTile extends StatelessWidget {
  const _PhotoTile({
    required this.child,
    required this.onRemove,
  });

  final Widget child;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: ProfilePhotosEditor._tileWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.white24,
                offset: Offset(-5, -5),
                blurRadius: 20,
              ),
              BoxShadow(
                color: Colors.black26,
                offset: Offset(5, 5),
                blurRadius: 20,
              ),
            ],
            color: Colors.white,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: child,
          ),
        ),
        Positioned(
          top: -8,
          right: -8,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ),
        Positioned(
          left: 4,
          bottom: 4,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.drag_handle,
              color: Colors.white,
              size: 18,
            ),
          ),
        ),
      ],
    );
  }
}
