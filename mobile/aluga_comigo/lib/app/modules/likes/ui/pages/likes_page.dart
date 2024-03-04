import 'package:blur/blur.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LikesPage extends StatefulWidget {
  const LikesPage({super.key});

  @override
  State<LikesPage> createState() => _LikesPageState();
}

class _LikesPageState extends State<LikesPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.white24,
                  blurRadius: 40,
                  offset: Offset(-20, -20),
                ),
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 40,
                  offset: Offset(20, 20),
                ),
              ],
            ),
            child: ExpansionTile(
              title: const Text(
                "Super Star(5)",
              ),
              shape: const Border(),
              childrenPadding: const EdgeInsets.symmetric(
                // vertical: 16,
                horizontal: 16,
              ),
              expandedAlignment: Alignment.topLeft,
              children: [
                const Divider(
                  height: 1,
                  thickness: 2,
                ),
                const Gap(16),
                LayoutBuilder(builder: (context, constraints) {
                  return Wrap(
                    alignment: WrapAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          width: constraints.maxWidth * .3,
                          height: constraints.maxWidth * .3 * (16 / 9),
                          child: GestureDetector(
                            child: CachedNetworkImage(
                              imageUrl:
                                  "https://img.freepik.com/fotos-premium/belas-jovens-exalam-beleza-natural-e-elegancia-geradas-pela-ia_188544-33017.jpg?w=1380",
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: constraints.maxWidth * .1 / 2),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          width: constraints.maxWidth * .3,
                          height: constraints.maxWidth * .3 * (16 / 9),
                          child: GestureDetector(
                            child: CachedNetworkImage(
                              imageUrl:
                                  "https://img.freepik.com/fotos-premium/belas-jovens-exalam-beleza-natural-e-elegancia-geradas-pela-ia_188544-33017.jpg?w=1380",
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: constraints.maxWidth * .1 / 2),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          width: constraints.maxWidth * .3,
                          height: constraints.maxWidth * .3 * (16 / 9),
                          child: GestureDetector(
                            child: CachedNetworkImage(
                              imageUrl:
                                  "https://img.freepik.com/fotos-premium/belas-jovens-exalam-beleza-natural-e-elegancia-geradas-pela-ia_188544-33017.jpg?w=1380",
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
                const Gap(16),
              ],
            ),
          ),
          const Gap(16),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.white24,
                  blurRadius: 40,
                  offset: Offset(-20, -20),
                ),
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 40,
                  offset: Offset(20, 20),
                ),
              ],
            ),
            child: ExpansionTile(
              title: const Text(
                "Curtidas(2)",
              ),
              shape: const Border(),
              childrenPadding: const EdgeInsets.symmetric(
                // vertical: 16,
                horizontal: 16,
              ),
              expandedAlignment: Alignment.topLeft,
              children: [
                const Divider(
                  height: 1,
                  thickness: 2,
                ),
                const Gap(16),
                LayoutBuilder(builder: (context, constraints) {
                  return Wrap(
                    alignment: WrapAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          width: constraints.maxWidth * .3,
                          height: constraints.maxWidth * .3 * (16 / 9),
                          child: GestureDetector(
                            child: Blur(
                              blur: 5,
                              blurColor: Colors.white,
                              child: SizedBox.expand(
                                child: CachedNetworkImage(
                                  imageUrl:
                                      "https://img.freepik.com/fotos-premium/belas-jovens-exalam-beleza-natural-e-elegancia-geradas-pela-ia_188544-33017.jpg?w=1380",
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: constraints.maxWidth * .1 / 2),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          width: constraints.maxWidth * .3,
                          height: constraints.maxWidth * .3 * (16 / 9),
                          child: GestureDetector(
                            child: Blur(
                              blur: 5,
                              blurColor: Colors.white,
                              child: SizedBox.expand(
                                child: CachedNetworkImage(
                                  imageUrl:
                                      "https://img.freepik.com/fotos-premium/belas-jovens-exalam-beleza-natural-e-elegancia-geradas-pela-ia_188544-33017.jpg?w=1380",
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: constraints.maxWidth * .1 / 2),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          width: constraints.maxWidth * .3,
                          height: constraints.maxWidth * .3 * (16 / 9),
                          child: GestureDetector(
                            child: Blur(
                              blur: 5,
                              blurColor: Colors.white,
                              child: SizedBox.expand(
                                child: CachedNetworkImage(
                                  imageUrl:
                                      "https://img.freepik.com/fotos-premium/belas-jovens-exalam-beleza-natural-e-elegancia-geradas-pela-ia_188544-33017.jpg?w=1380",
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
                const Gap(16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
