import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

import '../../interactor/enums/store_item_category.dart';
import '../../interactor/models/store_product.dart';
import 'store_product_icon.dart';

class StoreCategorySection extends StatelessWidget {
  final StoreItemCategory category;
  final Color backgroundColor;
  final Color headerColor;
  final Color headerTextColor;
  final List<StoreProduct> products;
  final void Function(StoreProduct product)? onProductTap;
  final String Function(StoreProduct product)? priceFor;
  final String? purchasingProductId;

  const StoreCategorySection({
    super.key,
    required this.category,
    required this.backgroundColor,
    required this.headerColor,
    required this.headerTextColor,
    required this.products,
    this.onProductTap,
    this.priceFor,
    this.purchasingProductId,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: backgroundColor,
            boxShadow: const [
              BoxShadow(
                color: Colors.white24,
                offset: Offset(-10, -10),
                blurRadius: 40,
              ),
              BoxShadow(
                color: Colors.black26,
                offset: Offset(10, 10),
                blurRadius: 20,
              ),
            ],
          ),
          padding: const EdgeInsets.only(
            top: 32,
            bottom: 16,
            left: 16,
            right: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category.description,
                style: GoogleFonts.rubik(
                  fontSize: 13,
                  color: headerTextColor.withValues(alpha: 0.85),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Gap(12),
              LayoutBuilder(
                builder: (context, constraints) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (final product in products)
                      _ProductCard(
                        product: product,
                        priceLabel: priceFor?.call(product) ?? product.priceLabel,
                        isPurchasing: purchasingProductId == product.id,
                        width: constraints.maxWidth * .3,
                        height: constraints.maxWidth * .45,
                        onTap: onProductTap == null
                            ? null
                            : () => onProductTap!(product),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
              bottom: Radius.circular(10),
            ),
            color: headerColor,
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 5),
                blurRadius: 5,
              ),
            ],
          ),
          child: Center(
            child: Text(
              category.title,
              style: GoogleFonts.rubik(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: headerTextColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProductCard extends StatelessWidget {
  final StoreProduct product;
  final String priceLabel;
  final bool isPurchasing;
  final double width;
  final double height;
  final VoidCallback? onTap;

  const _ProductCard({
    required this.product,
    required this.priceLabel,
    required this.isPurchasing,
    required this.width,
    required this.height,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Bounce(
      duration: Durations.short3,
      onPressed: onTap ?? () {},
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(color: Colors.grey),
        ),
        child: Column(
          children: [
            Flexible(
              flex: 4,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: StoreProductIconWidget(icon: product.icon),
                ),
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: Center(
                child: isPurchasing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        priceLabel,
                        style: GoogleFonts.rubik(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
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
