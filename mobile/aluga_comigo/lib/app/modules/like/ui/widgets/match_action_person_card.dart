import 'package:aluga_comigo/app/modules/customer/domain/enums/match_type.dart';
import 'package:aluga_comigo/app/shared/domain/constants/icons_asset.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

/// Card de pessoa com badge de curtida/favorito (estilo histórico).
class MatchActionPersonCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String photoUrl;
  final MatchType matchType;
  final double width;
  final VoidCallback? onTap;

  const MatchActionPersonCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.photoUrl,
    required this.matchType,
    required this.width,
    this.onTap,
  });

  static String _actionIconAsset(MatchType type) {
    return switch (type) {
      MatchType.like => IconsAsset.like,
      MatchType.favorite => IconsAsset.favorite,
      MatchType.unlike => IconsAsset.unlike,
      MatchType.none => IconsAsset.unlike,
    };
  }

  static Color _actionBadgeColor(MatchType type) {
    return switch (type) {
      MatchType.like => Colors.green.shade600,
      MatchType.favorite => Colors.amber.shade800,
      MatchType.unlike => Colors.red.shade700,
      MatchType.none => Colors.grey.shade600,
    };
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: width,
              height: width * 1.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 10),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    photoUrl.isEmpty
                        ? Container(color: Colors.grey.shade300)
                        : CachedNetworkImage(
                            imageUrl: photoUrl,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) =>
                                Container(color: Colors.grey.shade300),
                          ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: _actionBadgeColor(matchType),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.asset(
                          _actionIconAsset(matchType),
                          width: 16,
                          height: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Gap(6),
          Text(
            title,
            maxLines: subtitle == null ? 2 : 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: GoogleFonts.rubik(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (subtitle != null && subtitle!.isNotEmpty) ...[
            const Gap(2),
            Text(
              subtitle!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: GoogleFonts.rubik(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
