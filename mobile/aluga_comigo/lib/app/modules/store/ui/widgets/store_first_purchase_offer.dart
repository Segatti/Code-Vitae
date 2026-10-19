import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

import '../../interactor/models/store_product.dart';
import 'store_product_icon.dart';

class StoreFirstPurchaseOffer extends StatelessWidget {
  final StoreProduct product;
  final String priceLabel;
  final String? compareAtPriceLabel;
  final bool isPurchasing;
  final VoidCallback? onTap;

  const StoreFirstPurchaseOffer({
    super.key,
    required this.product,
    required this.priceLabel,
    this.compareAtPriceLabel,
    this.isPurchasing = false,
    this.onTap,
  });

  static const _accent = Color(0xFF2C29A3);

  @override
  Widget build(BuildContext context) {
    return Bounce(
      duration: Durations.short3,
      onPressed: onTap ?? () {},
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF3D3AB8), Color(0xFF2C29A3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: _accent.withValues(alpha: 0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: const BoxDecoration(
                color: Color(0xFFDF924B),
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Text(
                'Oferta de primeira compra — uso único',
                textAlign: TextAlign.center,
                style: GoogleFonts.rubik(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.label,
                              style: GoogleFonts.rubik(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const Gap(6),
                            Text(
                              product.description,
                              style: GoogleFonts.rubik(
                                fontSize: 13,
                                color: Colors.white.withValues(alpha: 0.9),
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(12),
                      SizedBox(
                        width: 72,
                        height: 72,
                        child: StoreProductIconWidget(icon: product.icon),
                      ),
                    ],
                  ),
                  const Gap(14),
                  _IncludedRow(
                    icon: Icons.bolt_rounded,
                    text: '7 dias de PowerUp no feed',
                  ),
                  const Gap(6),
                  _IncludedRow(
                    icon: Icons.star_rounded,
                    text: '5 créditos Super Star',
                  ),
                  const Gap(6),
                  _IncludedRow(
                    icon: Icons.chat_bubble_rounded,
                    text: '5 créditos Super Chat',
                  ),
                  const Gap(16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (compareAtPriceLabel != null) ...[
                        Text(
                          compareAtPriceLabel!,
                          style: GoogleFonts.rubik(
                            fontSize: 14,
                            color: Colors.white60,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: Colors.white60,
                          ),
                        ),
                        const Gap(10),
                      ],
                      Text(
                        priceLabel,
                        style: GoogleFonts.rubik(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFFFDC64),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDF924B),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: isPurchasing
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'Garantir oferta',
                                style: GoogleFonts.rubik(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IncludedRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _IncludedRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFFFFDC64)),
        const Gap(8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.rubik(
              fontSize: 13,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
