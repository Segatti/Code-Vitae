import 'package:aluga_comigo/app/modules/auth/domain/enums/user_desired_immobile.dart';
import 'package:aluga_comigo/app/modules/customer/data/models/customer_model.dart';
import 'package:aluga_comigo/app/shared/domain/extends/number.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:material_ui/material_ui.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../auth/domain/enums/user_skill.dart';
import 'customer_profile_card.dart';

class PersonFlipCard extends StatelessWidget {
  final PersonCustomerModel customer;
  final int Function(String) calculateAge;
  final String Function(UserSkill) getSkillName;
  final double? height;
  final VoidCallback? onBackPressed;
  final Future<bool> Function(FlipCardController)? onVerMaisPressed;

  const PersonFlipCard({
    super.key,
    required this.customer,
    required this.calculateAge,
    required this.getSkillName,
    this.height,
    this.onBackPressed,
    this.onVerMaisPressed,
  });

  @override
  Widget build(BuildContext context) {
    final flipController = FlipCardController();
    final cardHeight = height ?? MediaQuery.of(context).size.height * 0.7;

    return SizedBox(
      height: cardHeight,
      child: FlipCard(
        controller: flipController,
        flipOnTouch: false,
        front: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
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
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 170),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child: CachedNetworkImage(
                      height: cardHeight,
                      imageUrl: customer.photos.firstOrNull ?? "",
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) {
                        return Center(
                          child: const Icon(
                            Icons.person,
                            size: 100,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (customer.cityState.isNotEmpty)
                          Container(
                            height: 30,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(customer.cityState),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    height: 200,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    width: double.infinity,
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              customer.name.split(" ").first,
                              style: GoogleFonts.rubik(
                                fontSize: 32,
                                fontWeight: FontWeight.w500,
                                height: 1,
                              ),
                            ),
                            const Gap(12),
                            Visibility(
                              visible: customer.dateBirth.isNotEmpty,
                              child: Text(
                                "${calculateAge(customer.dateBirth)} anos",
                                style: GoogleFonts.rubik(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Gap(4),
                        if (customer.shortDescription.isNotEmpty)
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  customer.shortDescription,
                                  style: GoogleFonts.rubik(
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    if (customer.desiredImmobile !=
                                        UserDesiredImmobile.none) ...[
                                      const Gap(8),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            color: Colors.grey,
                                            width: 2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        height: 40,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        child: Center(
                                          child: Text(
                                            customer.desiredImmobile.title,
                                            style: GoogleFonts.rubik(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                    if (customer.priceMaxImmobile > 0) ...[
                                      const Gap(8),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            color: Colors.grey,
                                            width: 2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        height: 40,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        child: Center(
                                          child: Text(
                                            customer.priceMaxImmobile.toMoney(),
                                            style: GoogleFonts.rubik(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                    const Gap(8),
                                  ],
                                ),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: const Color(0XFFDF924B),
                                fixedSize: const Size(110, 40),
                                foregroundColor: Colors.amber,
                              ),
                              onPressed: () async {
                                if (onVerMaisPressed != null) {
                                  final result = await onVerMaisPressed!(flipController);
                                  if (result) {
                                    flipController.toggleCard();
                                  }
                                } else {
                                  flipController.toggleCard();
                                }
                              },
                              child: Text(
                                "Ver mais",
                                style: GoogleFonts.rubik(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
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
            ],
          ),
        ),
        back: CustomerProfileCard(
          customer: customer,
          calculateAge: calculateAge,
          getSkillName: getSkillName,
          onBackPressed: onBackPressed ?? () {
            flipController.toggleCard();
          },
        ),
      ),
    );
  }
}

