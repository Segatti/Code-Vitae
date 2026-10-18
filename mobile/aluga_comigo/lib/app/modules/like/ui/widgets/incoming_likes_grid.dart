import 'package:blur/blur.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

import '../../data/models/incoming_like_model.dart';

class IncomingLikesGrid extends StatelessWidget {
  final List<IncomingLikeModel> items;
  final bool blurPhotos;
  final bool Function(IncomingLikeModel item)? blurForItem;
  final void Function(IncomingLikeModel item)? onItemTap;

  const IncomingLikesGrid({
    super.key,
    required this.items,
    this.blurPhotos = false,
    this.blurForItem,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          'Ninguém por aqui ainda.',
          style: GoogleFonts.rubik(color: Colors.black54, fontSize: 14),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          alignment: WrapAlignment.start,
          runSpacing: 16,
          children: [
            for (final item in items) ...[
              _PhotoTile(
                item: item,
                width: constraints.maxWidth * .3,
                blur: blurForItem?.call(item) ?? blurPhotos,
                onTap: onItemTap == null ? null : () => onItemTap!(item),
              ),
              SizedBox(width: constraints.maxWidth * .1 / 2),
            ],
          ],
        );
      },
    );
  }
}

class _PhotoTile extends StatelessWidget {
  final IncomingLikeModel item;
  final double width;
  final bool blur;
  final VoidCallback? onTap;

  const _PhotoTile({
    required this.item,
    required this.width,
    required this.blur,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final photoUrl = item.customer.photos.isNotEmpty
        ? item.customer.photos.first
        : '';

    final image = photoUrl.isEmpty
        ? Container(color: Colors.grey.shade300)
        : CachedNetworkImage(
            imageUrl: photoUrl,
            fit: BoxFit.cover,
            errorWidget: (_, _, _) => Container(color: Colors.grey.shade300),
          );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            width: width,
            height: width * (16 / 9),
            child: blur
                ? Blur(
                    blur: 5,
                    blurColor: Colors.white,
                    child: SizedBox.expand(child: image),
                  )
                : image,
          ),
        ),
      ),
    );
  }
}
