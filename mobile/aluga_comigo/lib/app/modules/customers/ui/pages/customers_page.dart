import 'package:cached_network_image/cached_network_image.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
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
                detectableSwipeDirections: const {
                  SwipeDirection.left,
                  SwipeDirection.right,
                  SwipeDirection.up,
                },
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
                              height: constraints.maxHeight - 170,
                              imageUrl:
                                  "https://www.kotaku.com.au/wp-content/uploads/2021/06/10/7858f36e82b049ed8d3383f3d229b6bc.jpg?resize=640,360",
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: 30,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                      child: const Row(
                                        children: [
                                          Text("4/5"),
                                          Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 30,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Center(
                                          child: Text("Cuiabá - MT")),
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
                                          "Hatsune Miku".split(" ")[0],
                                          style: GoogleFonts.rubik(
                                            fontSize: 32,
                                            fontWeight: FontWeight.w500,
                                            height: 1,
                                          ),
                                        ),
                                        const Gap(12),
                                        Text(
                                          "18 anos",
                                          style: GoogleFonts.rubik(
                                            fontSize: 16,
                                            color: Colors.black54,
                                          ),
                                        )
                                      ],
                                    ),
                                    const Gap(4),
                                    Row(
                                      children: [
                                        Text(
                                          "Descrição breve sobre mim....\nDescrição breve sobre mim....\nDescrição breve sobre mim....",
                                          style: GoogleFonts.rubik(
                                            fontSize: 16,
                                            color: Colors.black54,
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
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                      color: Colors.grey,
                                                      width: 2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                                  height: 40,
                                                  child: Center(
                                                    child: Text(
                                                      "Casa/Ap.",
                                                      style: GoogleFonts.rubik(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                ),
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
                                                            20),
                                                  ),
                                                  height: 40,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "R\$ 1500,00",
                                                      style: GoogleFonts.rubik(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const Gap(8),
                                              ],
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            backgroundColor:
                                                const Color(0XFFDF924B),
                                            fixedSize: const Size(110, 40),
                                            foregroundColor: Colors.amber,
                                          ),
                                          onPressed: () {
                                            flipController.toggleCard();
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Gap(8),
                                      Text(
                                        "dataaaaaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaaaa a a a aaaa  a a  a a a  a aa ataaaaaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaaaa a a a aaaa  a a  a a a  a aa ataaaaaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaaaa a a a aaaa  a a  a a a  a aa ataaaaaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaaaa a a a aaaa  a a  a a a  a aa ataaaaaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaaaa a a a aaaa  a a  a a a  a aa ataaaaaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaaaa a a a aaaa  a a  a a a  a aa ",
                                        maxLines: null,
                                      ),
                                      Gap(8),
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
                            const Gap(8),
                            Row(
                              children: [
                                const Text("Imóvel desejado"),
                                const Gap(8),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
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
                                    "Todos",
                                    style: GoogleFonts.rubik(),
                                  ),
                                )
                              ],
                            ),
                            const Gap(8),
                            Row(
                              children: [
                                const Text("Buscando imóvel até"),
                                const Gap(8),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
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
                                    "R\$ 1500,00",
                                    style: GoogleFonts.rubik(),
                                  ),
                                )
                              ],
                            ),
                            const Gap(8),
                            Row(
                              children: [
                                const Text("Estilo de vida"),
                                const Gap(8),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
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
                                    "Festeiro",
                                    style: GoogleFonts.rubik(),
                                  ),
                                )
                              ],
                            ),
                            const Gap(8),
                            const Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    thickness: 2,
                                  ),
                                ),
                                Gap(8),
                                Text("Habilidades"),
                                Gap(8),
                                Expanded(
                                  child: Divider(
                                    thickness: 2,
                                  ),
                                ),
                              ],
                            ),
                            const Gap(8),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Row(
                                      children: [
                                        Text("Mestre cuca"),
                                        Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Row(
                                      children: [
                                        Text("Mestre cuca"),
                                        Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Row(
                                      children: [
                                        Text("Mestre cuca"),
                                        Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Row(
                                      children: [
                                        Text("Mestre cuca"),
                                        Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Row(
                                      children: [
                                        Text("Mestre cuca"),
                                        Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
