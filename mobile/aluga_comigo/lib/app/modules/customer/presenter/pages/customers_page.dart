import 'package:aluga_comigo/app/modules/auth/domain/enums/user_skill.dart';
import 'package:aluga_comigo/app/modules/customer/domain/entities/customer.dart';
import 'package:aluga_comigo/app/shared/data/services/session_service.dart';
import 'package:aluga_comigo/app/shared/domain/constants/icons_asset.dart';
import 'package:aluga_comigo/app/shared/domain/extends/number.dart';
import 'package:aluga_comigo/app/shared/domain/extends/string.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swipable_stack/swipable_stack.dart';

import '../../../auth/domain/enums/user_desired_immobile.dart';
import '../../../auth/domain/enums/user_life_style.dart';
import '../controllers/customers_controller.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  final controller = Modular.get<ICustomersController>();
  final swipController = SwipableStackController();

  void _listenController() {
    setState(() {});
  }

  int _calculateAge(String dateBirth) {
    if (dateBirth.isEmpty) return 0;
    final date = dateBirth.toDate();
    if (date == null) return 0;
    final now = DateTime.now();
    int age = now.year - date.year;
    if (now.month < date.month ||
        (now.month == date.month && now.day < date.day)) {
      age--;
    }
    return age;
  }

  String _getSkillName(UserSkill skill) {
    switch (skill) {
      case UserSkill.cucaMaster:
        return "Mestre cuca";
      case UserSkill.ninjaInSweeping:
        return "Ninja na vassoura";
      case UserSkill.humanDishwasher:
        return "Lava-louças humano";
      case UserSkill.laundryOperator:
        return "Operador de lavanderia";
      case UserSkill.none:
        return "";
    }
  }

  // String _formatScore(double score) {
  //   if (score == 0) return "0/5";
  //   return "${score.toStringAsFixed(1)}/5";
  // }

  bool _isProfileComplete(Customer? customer) {
    if (customer == null) return false;

    return customer.name.isNotEmpty &&
        customer.dateBirth.isNotEmpty &&
        customer.photos.isNotEmpty &&
        (customer.shortDescription.isNotEmpty ||
            customer.longDescription.isNotEmpty) &&
        customer.cityState.isNotEmpty &&
        customer.phone.isNotEmpty &&
        customer.gender.isNotEmpty;
  }

  Future<void> _showIncompleteProfileDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 64,
                  color: Color(0XFFDF924B),
                ),
                const Gap(16),
                Text(
                  "Perfil Incompleto",
                  style: GoogleFonts.rubik(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Gap(16),
                Text(
                  "Você precisa completar seu perfil para visualizar os detalhes dos outros usuários.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.rubik(fontSize: 16, color: Colors.black54),
                ),
                const Gap(24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.grey, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          "Cancelar",
                          style: GoogleFonts.rubik(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const Gap(16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Modular.to.pushNamed("/config/profile");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0XFFDF924B),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          "Preencher",
                          style: GoogleFonts.rubik(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool> _checkProfileAndShowDetails(
    FlipCardController flipController,
  ) async {
    if (!_isProfileComplete(Customer.fromModel(SessionService.customer!))) {
      await _showIncompleteProfileDialog();
      return false;
    }

    // Se o perfil estiver completo, permite ver os detalhes
    flipController.toggleCard();
    return true;
  }

  @override
  void initState() {
    swipController.addListener(_listenController);
    controller.initialize();
    super.initState();
  }

  @override
  void dispose() {
    swipController.removeListener(_listenController);
    swipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        var list = controller.customers.toList();

        if (controller.loadingList.contains('getCustomers') ||
            controller.loadingList.contains('initialize')) {
          return const Center(child: CircularProgressIndicator());
        }

        if (list.isEmpty && !controller.hasMore) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.heart_broken, size: 48),
                Gap(16),
                Text(
                  "Você chegou ao fim, volte mais tarde!",
                  style: GoogleFonts.rubik(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Gap(50),
              ],
            ),
          );
        }

        if (list.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SwipableStack(
                    controller: swipController,
                    itemCount: list.length,
                    detectableSwipeDirections: const {
                      SwipeDirection.left,
                      SwipeDirection.right,
                      SwipeDirection.up,
                    },
                    stackClipBehaviour: Clip.none,
                    onSwipeCompleted: (index, direction) {
                      if ((index == list.length - 1) && controller.hasMore) {
                        controller.getCustomers();
                      }
                    },
                    builder: (context, properties) {
                      final itemIndex = properties.index % list.length;
                      final customer = list[itemIndex];

                      final flipController = FlipCardController();
                      return FlipCard(
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
                                      height: constraints.maxHeight,
                                      imageUrl:
                                          customer.photos.firstOrNull ?? "",
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
                                        // Container(
                                        //   height: 30,
                                        //   padding: const EdgeInsets.symmetric(
                                        //     horizontal: 8,
                                        //   ),
                                        //   decoration: BoxDecoration(
                                        //     color: Colors.white,
                                        //     borderRadius: BorderRadius.circular(
                                        //       40,
                                        //     ),
                                        //   ),
                                        //   child: Row(
                                        //     children: [
                                        //       Text(
                                        //         _formatScore(customer.score),
                                        //       ),
                                        //       const Icon(
                                        //         Icons.star,
                                        //         color: Colors.amber,
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),
                                        if (customer.cityState.isNotEmpty)
                                          Container(
                                            height: 30,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(20),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
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
                                              visible:
                                                  customer.dateBirth.isNotEmpty,
                                              child: Text(
                                                "${_calculateAge(customer.dateBirth)} anos",
                                                style: GoogleFonts.rubik(
                                                  fontSize: 16,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Gap(4),
                                        if (customer
                                            .shortDescription
                                            .isNotEmpty)
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        const Spacer(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(
                                                  children: [
                                                    if (customer
                                                            .desiredImmobile !=
                                                        UserDesiredImmobile
                                                            .none) ...[
                                                      const Gap(8),
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(
                                                            color: Colors.grey,
                                                            width: 2,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                20,
                                                              ),
                                                        ),
                                                        height: 40,
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                              vertical: 4,
                                                            ),
                                                        child: Center(
                                                          child: Text(
                                                            customer
                                                                .desiredImmobile
                                                                .title,
                                                            style:
                                                                GoogleFonts.rubik(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                    if (customer
                                                            .priceMaxImmobile >
                                                        0) ...[
                                                      const Gap(8),
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(
                                                            color: Colors.grey,
                                                            width: 2,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                20,
                                                              ),
                                                        ),
                                                        height: 40,
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                              vertical: 4,
                                                            ),
                                                        child: Center(
                                                          child: Text(
                                                            customer
                                                                .priceMaxImmobile
                                                                .toMoney(),
                                                            style:
                                                                GoogleFonts.rubik(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
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
                                                backgroundColor: const Color(
                                                  0XFFDF924B,
                                                ),
                                                fixedSize: const Size(110, 40),
                                                foregroundColor: Colors.amber,
                                              ),
                                              onPressed: () {
                                                _checkProfileAndShowDetails(
                                                  flipController,
                                                );
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
                        back: Container(
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
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Text(
                                //   "Nome",
                                //   style: GoogleFonts.rubik(
                                //     color: Colors.black,
                                //     fontSize: 32,
                                //     fontWeight: FontWeight.w500,
                                //     height: 1,
                                //   ),
                                // ),
                                Text(
                                  "Descrição completa",
                                  style: GoogleFonts.rubik(
                                    color: Colors.grey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const Gap(4),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Gap(8),
                                          Text(
                                            customer.longDescription.isNotEmpty
                                                ? customer.longDescription
                                                : customer.shortDescription,
                                            maxLines: null,
                                            style: GoogleFonts.rubik(
                                              fontSize: 14,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const Gap(8),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const Gap(8),
                                Row(
                                  children: [
                                    const Text("Tarefas Domésticas"),
                                    const Gap(16),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        backgroundColor: Colors.orange,
                                        fixedSize: const Size(100, 0),
                                      ),
                                      onPressed: () {},
                                      child: Text(
                                        "Ver",
                                        style: GoogleFonts.rubik(
                                          color: Colors.white,
                                          // fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (customer.desiredImmobile !=
                                    UserDesiredImmobile.none) ...[
                                  const Gap(8),
                                  Row(
                                    children: [
                                      const Text("Imóvel desejado"),
                                      const Gap(8),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          border: Border.all(
                                            color: Colors.grey,
                                            width: 2,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        child: Text(
                                          customer.desiredImmobile.title,
                                          style: GoogleFonts.rubik(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                if (customer.priceMaxImmobile > 0) ...[
                                  const Gap(8),
                                  Row(
                                    children: [
                                      const Text("Buscando imóvel até"),
                                      const Gap(8),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          border: Border.all(
                                            color: Colors.grey,
                                            width: 2,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        child: Text(
                                          customer.priceMaxImmobile.toMoney(),
                                          style: GoogleFonts.rubik(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                if (customer.lifeStyle !=
                                    UserLifeStyle.none) ...[
                                  const Gap(8),
                                  Row(
                                    children: [
                                      const Text("Estilo de vida"),
                                      const Gap(8),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          border: Border.all(
                                            color: Colors.grey,
                                            width: 2,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        child: Text(
                                          customer.lifeStyle.title,
                                          style: GoogleFonts.rubik(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                const Gap(8),
                                const Row(
                                  children: [
                                    Expanded(child: Divider(thickness: 2)),
                                    Gap(8),
                                    Text("Habilidades"),
                                    Gap(8),
                                    Expanded(child: Divider(thickness: 2)),
                                  ],
                                ),
                                if (customer.skills.isNotEmpty) ...[
                                  const Gap(8),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: customer.skills
                                          .where(
                                            (skill) => skill != UserSkill.none,
                                          )
                                          .map((skill) {
                                            final skillName = _getSkillName(
                                              skill,
                                            );
                                            if (skillName.isEmpty)
                                              return const SizedBox.shrink();
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                right: 8,
                                              ),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                    width: 2,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Text(skillName),
                                                    const Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                      size: 16,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          })
                                          .toList(),
                                    ),
                                  ),
                                ],
                                const Gap(16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          backgroundColor: Colors.white,
                                          side: const BorderSide(
                                            width: 3,
                                            color: Colors.orange,
                                          ),
                                        ),
                                        onPressed: () {
                                          flipController.toggleCard();
                                        },
                                        child: Text(
                                          "Voltar",
                                          style: GoogleFonts.rubik(
                                            color: Colors.grey,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const Gap(16),
            Row(
              children: [
                const Gap(16),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      swipController.next(swipeDirection: SwipeDirection.left);
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white24,
                            offset: Offset(-10, -10),
                            blurRadius: 40,
                          ),
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(10, 10),
                            blurRadius: 40,
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(50),
                          right: Radius.circular(20),
                        ),
                      ),
                      height: 60,
                      padding: const EdgeInsets.all(8),
                      child: Image.asset(
                        IconsAsset.unlike,
                        width: 45,
                        height: 45,
                      ),
                    ),
                  ),
                ),
                const Gap(16),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      swipController.next(swipeDirection: SwipeDirection.up);
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white24,
                            offset: Offset(-10, -10),
                            blurRadius: 40,
                          ),
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(10, 10),
                            blurRadius: 40,
                          ),
                        ],
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(10),
                          right: Radius.circular(10),
                        ),
                        color: Colors.white,
                      ),
                      height: 60,
                      padding: const EdgeInsets.all(8),
                      child: Image.asset(
                        IconsAsset.favorite,
                        width: 45,
                        height: 45,
                      ),
                    ),
                  ),
                ),
                const Gap(16),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      swipController.next(swipeDirection: SwipeDirection.right);
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white24,
                            offset: Offset(-10, -10),
                            blurRadius: 40,
                          ),
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(10, 10),
                            blurRadius: 40,
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(50),
                          left: Radius.circular(20),
                        ),
                      ),
                      height: 60,
                      padding: const EdgeInsets.all(8),
                      child: Image.asset(
                        IconsAsset.like,
                        width: 45,
                        height: 45,
                      ),
                    ),
                  ),
                ),
                const Gap(16),
              ],
            ),
            const Gap(90),
          ],
        );
      },
    );
  }
}
