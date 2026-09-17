import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';
import 'package:swipable_stack/swipable_stack.dart';

import '../../../../shared/domain/constants/icons_asset.dart';
import '../../../../shared/domain/helpers/maps_helper.dart';
import '../../../../shared/presenter/helpers/incomplete_profile_helper.dart';
import '../../../../shared/presenter/helpers/inventory_prompt_helper.dart';
import '../../../../shared/presenter/helpers/swipable_stack_helper.dart';
import '../../../customer/data/models/customer_model.dart';
import '../../../customer/domain/enums/match_type.dart';
import '../../../customer/presenter/widgets/house_flip_card.dart';
import '../../../customer/presenter/widgets/match_celebration_dialog.dart';
import '../controllers/houses_controller.dart';
import '../widgets/super_chat_immobile_dialog.dart';

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

  Future<void> _superChatForHouse(
    ImmobileCustomerModel house,
    List<CustomerModel> list,
  ) async {
    if (!await InventoryPromptHelper.ensureSuperChatAvailable(context)) {
      return;
    }
    if (!mounted) return;
    final message = await SuperChatImmobileDialog.show(context);
    if (message == null || !mounted) return;

    final superChatResult =
        await controller.superChatFavoriteImmobile(house, message);
    if (!mounted) return;

    if (!superChatResult.removed && controller.errorMessage.isNotEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(controller.errorMessage)));
      return;
    }

    if (superChatResult.removed) {
      swipController.next(swipeDirection: SwipeDirection.up);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        SwipableStackHelper.resetToFront(swipController);
      });
      if (swipController.currentIndex >= controller.houses.length - 1 &&
          controller.hasMore) {
        controller.getHouses();
      }
      if (superChatResult.mutualMatch != null) {
        await MatchCelebrationDialog.show(
          context,
          superChatResult.mutualMatch!,
        );
      }
    }
  }

  Future<void> _onSwipeCompleted(
    int index,
    SwipeDirection direction,
    List<CustomerModel> list,
  ) async {
    final itemIndex = index % list.length;
    final house = list[itemIndex];
    final matchType = _matchTypeFromDirection(direction);
    if (matchType == MatchType.favorite) {
      return;
    }
    if (matchType != null) {
      final swipeResult = await controller.handleSwipe(house, matchType);
      if (swipeResult.removed && mounted) {
        SwipableStackHelper.resetToFront(swipController);
      }
      if (mounted && swipeResult.mutualMatch != null) {
        await MatchCelebrationDialog.show(context, swipeResult.mutualMatch!);
      }
      if (mounted && controller.errorMessage.isNotEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(controller.errorMessage)));
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
    super.initState();
    SwipableStackHelper.resetToFront(swipController);
    controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        var list = controller.houses.toList();

        final isLoadingInitial =
            list.isEmpty &&
            (controller.loadingList.contains('getHouses') ||
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
                    onWillMoveNext: (index, direction) {
                      if (direction != SwipeDirection.up) return true;
                      final house = list[index % list.length];
                      if (house is! ImmobileCustomerModel) return false;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _superChatForHouse(house, list);
                      });
                      return false;
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
                      if (list.isEmpty) return;
                      final house =
                          list[swipController.currentIndex % list.length];
                      if (house is ImmobileCustomerModel) {
                        _superChatForHouse(house, list);
                      }
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
                      child: SvgPicture.asset(
                        IconsAsset.chat,
                        width: 45,
                        height: 45,
                        colorFilter: ColorFilter.mode(
                          Colors.amber,
                          BlendMode.srcIn,
                        ),
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
