import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

import '../../interactor/enums/store_item_category.dart';
import '../../interactor/models/store_product.dart';
import 'store_product_icon.dart';

class StoreCategorySection extends StatelessWidget {
  final StoreItemCategory category;
  final List<StoreProduct> products;
  final void Function(StoreProduct product)? onProductTap;
  final String Function(StoreProduct product)? priceFor;
  final String? purchasingProductId;

  const StoreCategorySection({
    super.key,
    required this.category,
    required this.products,
    this.onProductTap,
    this.priceFor,
    this.purchasingProductId,
  });

  @override
  Widget build(BuildContext context) {
    final accent = _StoreCategoryStyle.accentColor(category);
    final surface = _StoreCategoryStyle.surfaceColor(category);
    final icon = _StoreCategoryStyle.headerIcon(category);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: accent.withValues(alpha: 0.35)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.white, size: 22),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.title,
                      style: GoogleFonts.rubik(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      category.tagline,
                      style: GoogleFonts.rubik(
                        fontSize: 13,
                        color: const Color(0xFF555555),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(12),
          Text(
            category.description,
            style: GoogleFonts.rubik(
              fontSize: 13,
              color: const Color(0xFF666666),
              height: 1.35,
            ),
          ),
          const Gap(10),
          ...category.benefits.map(
            (benefit) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle, size: 16, color: accent),
                  const Gap(8),
                  Expanded(
                    child: Text(
                      benefit,
                      style: GoogleFonts.rubik(
                        fontSize: 12,
                        color: const Color(0xFF444444),
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Gap(16),
          LayoutBuilder(
            builder: (context, constraints) => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < products.length; i++) ...[
                  if (i > 0) const Gap(8),
                  Expanded(
                    child: _ProductCard(
                      product: products[i],
                      accentColor: accent,
                      priceLabel:
                          priceFor?.call(products[i]) ??
                          products[i].priceLabel,
                      isPurchasing:
                          purchasingProductId == products[i].id,
                      onTap: onProductTap == null
                          ? null
                          : () => onProductTap!(products[i]),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StoreCategoryStyle {
  static Color accentColor(StoreItemCategory category) => switch (category) {
    StoreItemCategory.superStar => const Color(0xFFE6A800),
    StoreItemCategory.superChat => const Color(0xFF5350C3),
    StoreItemCategory.powerUp => const Color(0xFFDF924B),
  };

  static Color surfaceColor(StoreItemCategory category) => switch (category) {
    StoreItemCategory.superStar => const Color(0xFFFFF8E1),
    StoreItemCategory.superChat => const Color(0xFFF0EFFF),
    StoreItemCategory.powerUp => const Color(0xFFFFF3E0),
  };

  static IconData headerIcon(StoreItemCategory category) => switch (category) {
    StoreItemCategory.superStar => Icons.star_rounded,
    StoreItemCategory.superChat => Icons.chat_bubble_rounded,
    StoreItemCategory.powerUp => Icons.bolt_rounded,
  };
}

class _ProductCard extends StatelessWidget {
  final StoreProduct product;
  final Color accentColor;
  final String priceLabel;
  final bool isPurchasing;
  final VoidCallback? onTap;

  const _ProductCard({
    required this.product,
    required this.accentColor,
    required this.priceLabel,
    required this.isPurchasing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = product.isRecommended
        ? accentColor
        : const Color(0xFFACACAC);

    return Bounce(
      duration: Durations.short3,
      onPressed: onTap ?? () {},
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(
            color: borderColor,
            width: product.isRecommended ? 2 : 1,
          ),
          boxShadow: product.isRecommended
              ? [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            if (product.badgeLabel != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                ),
                child: Text(
                  product.badgeLabel!,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.rubik(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
              child: SizedBox(
                height: 56,
                child: StoreProductIconWidget(icon: product.icon),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              child: Text(
                product.label,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: GoogleFonts.rubik(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Colors.black,
                ),
              ),
            ),
            if (product.description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  product.description,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.rubik(
                    fontSize: 10,
                    height: 1.25,
                    color: const Color(0xFF666666),
                  ),
                ),
              ),
            const Gap(8),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: isPurchasing
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Comprar\n$priceLabel',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.rubik(
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                            height: 1.2,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
