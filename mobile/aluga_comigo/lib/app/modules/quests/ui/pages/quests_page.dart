import 'dart:ui';

import 'package:aluga_comigo/app/modules/quests/interactor/enums/type_reward.dart';
import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../interactor/models/quest.dart';

class QuestsPage extends StatefulWidget {
  const QuestsPage({super.key});

  @override
  State<QuestsPage> createState() => _QuestsPageState();
}

class _QuestsPageState extends State<QuestsPage> {
  late DateTime dayReset;
  List<Quest> quests = [
    const Quest(
      title: "Curta 10 pessoas",
      amountRewards: 5,
      isCompleted: false,
      typeRewards: TypeRewards.like,
    ),
    const Quest(
      title: "Dê 1 Super Star!",
      amountRewards: 2,
      isCompleted: true,
      typeRewards: TypeRewards.superStar,
    ),
    const Quest(
      title: "Dê 1 Super Star!",
      amountRewards: 2,
      isCompleted: true,
      typeRewards: TypeRewards.superStar,
    ),
    const Quest(
      title: "Curta 10 pessoas",
      amountRewards: 5,
      isCompleted: false,
      typeRewards: TypeRewards.like,
    ),
  ];

  @override
  void initState() {
    super.initState();
    dayReset = DateTime.now().endOfISOWeek.addDays(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.chevron_left,
            size: 40,
            color: Colors.grey,
          ),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            Expanded(
              child: Text(
                'Missões',
                style: GoogleFonts.rubik(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const Divider(
            height: 2,
            thickness: 2,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    "Missões reiniciam em: ${dayReset.format("dd/MM")} às 00:00",
                    style: GoogleFonts.rubik(
                      color: const Color(0xFF777777),
                    ),
                  ),
                  const Gap(16),
                  Row(
                    children: [
                      Flexible(
                        flex: 3,
                        child: Center(
                          child: Text(
                            "Descrição",
                            style: GoogleFonts.rubik(
                              color: const Color(0xFF777777),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Center(
                          child: Text(
                            "Prêmio",
                            style: GoogleFonts.rubik(
                              color: const Color(0xFF777777),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(8),
                  Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, index) => Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFFEAEAEA),
                            ),
                            child: Row(
                              children: [
                                Flexible(
                                  flex: 3,
                                  child: Center(
                                    child: Text(
                                      quests[index].title ?? '',
                                      style: GoogleFonts.rubik(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 50,
                                  color: const Color(0xFFACACAC),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${quests[index].amountRewards}x",
                                          style: GoogleFonts.rubik(
                                            color: const Color(0xFF787878),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const Gap(8),
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: const BoxDecoration(
                                            color: Colors.blue,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: quests[index].isCompleted ?? false,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 5,
                                  sigmaY: 5,
                                ),
                                child: Shimmer(
                                  child: Container(
                                    height: 50,
                                    color: Colors.orange.withOpacity(.8),
                                    child: Center(
                                      child: Text(
                                        "Receber Prêmio",
                                        style: GoogleFonts.rubik(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      separatorBuilder: (_, __) => const Gap(16),
                      itemCount: quests.length,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
