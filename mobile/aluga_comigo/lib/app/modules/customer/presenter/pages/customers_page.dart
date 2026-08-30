import 'package:aluga_comigo/app/modules/auth/domain/enums/user_skill.dart';
import 'package:aluga_comigo/app/shared/data/services/session_service.dart';
import 'package:aluga_comigo/app/shared/domain/constants/icons_asset.dart';
import 'package:aluga_comigo/app/shared/domain/extends/string.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swipable_stack/swipable_stack.dart';

import '../../../auth/domain/enums/type_immobile.dart';
import '../../data/models/customer_model.dart';
import '../controllers/customers_controller.dart';
import '../widgets/person_flip_card.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  final controller = inject<ICustomersController>();
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

  bool _isProfileComplete(CustomerModel? model) {
    if (model == null) return false;

    switch (model) {
      case PersonCustomerModel _:
        return model.name.isNotEmpty &&
        model.dateBirth.isNotEmpty &&
        model.photos.isNotEmpty &&
        (model.shortDescription.isNotEmpty ||
            model.longDescription.isNotEmpty) &&
        model.cityState.isNotEmpty &&
        model.phone.isNotEmpty &&
        model.gender.isNotEmpty;
      case ImmobileCustomerModel _:
        return model.cep.isNotEmpty &&
        model.price > 0 &&
        model.photos.isNotEmpty &&
        (model.shortDescription.isNotEmpty ||
            model.longDescription.isNotEmpty) &&
        model.cityState.isNotEmpty &&
        model.phone.isNotEmpty &&
        model.typeImmobile != TypeImmobile.none;
    }
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
                          context.pushNamed("/config/profile");
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
    if (!_isProfileComplete(SessionService.customer!)) {
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

                      switch (customer) {
                        case PersonCustomerModel _:
                          return PersonFlipCard(
                            customer: customer,
                            calculateAge: _calculateAge,
                            getSkillName: _getSkillName,
                            height: constraints.maxHeight,
                            onVerMaisPressed: (flipController) async {
                              return await _checkProfileAndShowDetails(
                                flipController,
                              );
                            },
                          );
                        case ImmobileCustomerModel _:
                          return SizedBox.shrink();
                      }
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
