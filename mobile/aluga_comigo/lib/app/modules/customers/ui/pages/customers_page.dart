import 'package:cached_network_image/cached_network_image.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:swipable_stack/swipable_stack.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  final controller = SwipableStackController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SwipableStack(
                controller: controller,
                builder: (context, properties) {
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
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                            child: CachedNetworkImage(
                              height: constraints.maxHeight * .7,
                              imageUrl:
                                  "https://www.kotaku.com.au/wp-content/uploads/2021/06/10/7858f36e82b049ed8d3383f3d229b6bc.jpg?resize=640,360",
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  flipController.toggleCard();
                                },
                                child: const Text("Ver mais"),
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
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            const Text("Nome"),
                            const Text("Descrição completa"),
                            Container(
                              height: 200,
                              width: double.infinity,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                flipController.toggleCard();
                              },
                              child: const Text("Voltar"),
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
                  controller.next(swipeDirection: SwipeDirection.left);
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
                  controller.next(swipeDirection: SwipeDirection.up);
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
                    Icons.star,
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
                  controller.next(swipeDirection: SwipeDirection.right);
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
  }
}
