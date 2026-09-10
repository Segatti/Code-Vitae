import 'package:blur/blur.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_ui/material_ui.dart';

class IncomingLikesGrid extends StatelessWidget {
  final List<String> photoUrls;
  final bool blurPhotos;

  const IncomingLikesGrid({
    super.key,
    required this.photoUrls,
    this.blurPhotos = false,
  });

  @override
  Widget build(BuildContext context) {
    if (photoUrls.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: Text('Ninguém por aqui ainda.'),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          alignment: WrapAlignment.start,
          runSpacing: 16,
          children: [
            for (final photoUrl in photoUrls) ...[
              _PhotoTile(
                photoUrl: photoUrl,
                width: constraints.maxWidth * .3,
                blur: blurPhotos,
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
  final String photoUrl;
  final double width;
  final bool blur;

  const _PhotoTile({
    required this.photoUrl,
    required this.width,
    required this.blur,
  });

  @override
  Widget build(BuildContext context) {
    final image = CachedNetworkImage(
      imageUrl: photoUrl,
      fit: BoxFit.cover,
      errorWidget: (_, __, ___) => Container(color: Colors.grey.shade300),
    );

    return ClipRRect(
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
    );
  }
}
