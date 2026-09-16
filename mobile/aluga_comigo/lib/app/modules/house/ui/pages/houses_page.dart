import 'package:flip_card/flip_card_controller.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swipable_stack/swipable_stack.dart';

import '../../../../shared/domain/helpers/maps_helper.dart';
import '../../../../shared/presenter/helpers/incomplete_profile_helper.dart';
import '../../../customer/data/models/customer_model.dart';
import '../../../customer/domain/enums/match_type.dart';
import '../../../customer/presenter/widgets/house_flip_card.dart';
import '../controllers/houses_controller.dart';

class HousesPage extends StatefulWidget {
  const HousesPage({super.key});

  @override
  State<HousesPage> createState() => _HousesPageState();
}

class _HousesPageState extends State<HousesPage> {
  final controller = inject<IHousesController>();
  final swipController = SwipableStackController();

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
    final house = list[itemIndex];
    final matchType = _matchTypeFromDirection(direction);
    if (matchType != null) {
      await controller.handleSwipe(house, matchType);
      if (mounted && controller.errorMessage.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(controller.errorMessage)),
        );
      }
    }
    if ((index == list.length - 1) && controller.hasMore) {
      controller.getHouses();
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
    controller.initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        var list = controller.houses.toList();

        if (controller.loadingList.contains('getHouses') ||
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
                      final house = list[itemIndex];

                      switch (house) {
                        case PersonCustomerModel _:
                          return SizedBox.shrink();
                        case ImmobileCustomerModel _:
                          return HouseFlipCard(
                            immobile: house,
                            height: constraints.maxHeight,
                            onVerMaisPressed: (flipController) async {
                              return await _checkProfileAndShowDetails(
                                flipController,
                              );
                            },
                            onVerNoMapaPressed: () {
                              MapsHelper.openLocation(
                                cep: house.cep,
                                cityState: house.cityState,
                              );
                            },
                          );
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
                      child: const Icon(
                        Icons.cancel,
                        color: Colors.red,
                        size: 45,
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
                      child: const Icon(
                        Icons.chat,
                        color: Colors.amber,
                        size: 45,
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
                      child: const Icon(
                        Icons.heart_broken,
                        color: Colors.blue,
                        size: 45,
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
