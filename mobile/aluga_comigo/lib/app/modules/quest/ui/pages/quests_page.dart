import 'dart:ui';

import 'package:aluga_comigo/app/modules/quest/data/models/quest_progress_model.dart';
import 'package:aluga_comigo/app/modules/quest/interactor/enums/type_reward.dart';
import 'package:aluga_comigo/app/modules/quest/ui/controllers/quests_controller.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class QuestsPage extends StatefulWidget {
  const QuestsPage({super.key});

  @override
  State<QuestsPage> createState() => _QuestsPageState();
}

class _QuestsPageState extends State<QuestsPage> {
  late final IQuestsController controller;
  late DateTime dayReset;

  @override
  void initState() {
    super.initState();
    controller = inject<IQuestsController>();
    dayReset = DateTime.now().lastDayOfWeek.add(const Duration(days: 1));
    controller.initialize();
  }

  IconData _rewardIcon(TypeRewards type) {
    return switch (type) {
      TypeRewards.superStar => Icons.star,
      TypeRewards.superChat => Icons.chat_bubble,
      TypeRewards.like => Icons.favorite,
      TypeRewards.none => Icons.card_giftcard,
    };
  }

  Future<void> _claim(QuestProgressModel quest) async {
    final success = await controller.claimReward(quest.id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? 'Prêmio recebido!' : controller.errorMessage),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.chevron_left, size: 40, color: Colors.grey),
        ),
        titleSpacing: 0,
        title: Text(
          'Missões',
          style: GoogleFonts.rubik(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          if (controller.loadingList.contains('loadQuests')) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              const Divider(height: 2, thickness: 2),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Missões reiniciam em: ${DateFormat('dd/MM').format(dayReset)} às 00:00',
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
                                'Descrição',
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
                                'Prêmio',
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
                        child: controller.quests.isEmpty
                            ? Center(
                                child: Text(
                                  controller.errorMessage.isNotEmpty
                                      ? controller.errorMessage
                                      : 'Nenhuma missão disponível.',
                                  style: GoogleFonts.rubik(
                                    color: Colors.black54,
                                  ),
                                ),
                              )
                            : ListView.separated(
                                itemBuilder: (context, index) {
                                  final quest = controller.quests[index];
                                  return Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          color: const Color(0xFFEAEAEA),
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                  8,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      quest.title,
                                                      style: GoogleFonts.rubik(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      '${quest.progressCount}/${quest.targetCount}',
                                                      style: GoogleFonts.rubik(
                                                        color: Colors.black54,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 1,
                                              height: 50,
                                              color: const Color(0xFFACACAC),
                                            ),
                                            SizedBox(
                                              width: 100,
                                              child: Center(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      '${quest.rewardAmount}x',
                                                      style: GoogleFonts.rubik(
                                                        color: const Color(
                                                          0xFF787878,
                                                        ),
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    const Gap(8),
                                                    Icon(
                                                      _rewardIcon(
                                                        quest.rewardType,
                                                      ),
                                                      color: const Color(
                                                        0xFF2C29A3,
                                                      ),
                                                      size: 28,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (quest.canClaim)
                                        GestureDetector(
                                          onTap: () => _claim(quest),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            child: BackdropFilter(
                                              filter: ImageFilter.blur(
                                                sigmaX: 5,
                                                sigmaY: 5,
                                              ),
                                              child: Shimmer(
                                                child: Container(
                                                  height: 50,
                                                  color: Colors.orange
                                                      .withValues(alpha: .8),
                                                  child: Center(
                                                    child: Text(
                                                      'Receber Prêmio',
                                                      style: GoogleFonts.rubik(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      else if (quest.isCompleted &&
                                          quest.isClaimed)
                                        Positioned.fill(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            child: ColoredBox(
                                              color: Colors.white
                                                  .withValues(alpha: 0.82),
                                              child: Center(
                                                child: Text(
                                                  'Prêmio resgatado',
                                                  style: GoogleFonts.rubik(
                                                    color: const Color(
                                                      0xFF2C29A3,
                                                    ),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  );
                                },
                                separatorBuilder: (_, __) => const Gap(16),
                                itemCount: controller.quests.length,
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
