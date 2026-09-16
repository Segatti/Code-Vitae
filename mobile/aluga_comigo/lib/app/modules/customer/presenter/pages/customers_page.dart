import 'package:aluga_comigo/app/modules/auth/domain/enums/user_skill.dart';
import 'package:aluga_comigo/app/shared/domain/constants/icons_asset.dart';
import 'package:aluga_comigo/app/shared/presenter/helpers/incomplete_profile_helper.dart';
import 'package:aluga_comigo/app/shared/domain/extends/string.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swipable_stack/swipable_stack.dart';

import '../../data/models/customer_model.dart';
import '../../domain/enums/match_type.dart';
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

  MatchType? _matchTypeFromDirection(SwipeDirection direction) {
    return switch (direction) {
      SwipeDirection.left => MatchType.unlike,
      SwipeDirection.up => MatchType.favorite,
      SwipeDirection.right => MatchType.like,
      _ => null,
    };
  }

  Future<void> _onSwipeCompleted(
    int index,
    SwipeDirection direction,
    List<CustomerModel> list,
  ) async {
    final itemIndex = index % list.length;
    final customer = list[itemIndex];
    final matchType = _matchTypeFromDirection(direction);
    if (matchType != null) {
      await controller.handleSwipe(customer, matchType);
      if (mounted && controller.errorMessage.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(controller.errorMessage)),
        );
      }
    }
    if ((index == list.length - 1) && controller.hasMore) {
      controller.getCustomers();
    }
  }

  Future<bool> _checkProfileAndShowDetails(
    FlipCardController flipController,
  ) async {
    if (!await IncompleteProfileHelper.canShowDetails(context)) {
      return false;
    }

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

        final isLoadingInitial = list.isEmpty &&
            (controller.loadingList.contains('getCustomers') ||
                controller.loadingList.contains('initialize'));

        if (isLoadingInitial) {
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
                      _onSwipeCompleted(index, direction, list);
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
