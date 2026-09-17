import 'package:aluga_comigo/app/modules/chats/domain/entities/chat_immobile_offer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

class ChatImmobileOfferCard extends StatelessWidget {
  final ChatImmobileOffer offer;
  final VoidCallback onTap;

  const ChatImmobileOfferCard({
    super.key,
    required this.offer,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Material(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: offer.immobilePhoto.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: offer.immobilePhoto,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 48,
                          height: 48,
                          color: Colors.amber.shade100,
                          child: const Icon(Icons.home_work, color: Colors.amber),
                        ),
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Imóvel oferecido',
                        style: GoogleFonts.rubik(
                          fontSize: 11,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        offer.immobileName.isNotEmpty
                            ? offer.immobileName
                            : 'Ver anúncio',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.rubik(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.open_in_new, size: 20, color: Colors.black45),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
