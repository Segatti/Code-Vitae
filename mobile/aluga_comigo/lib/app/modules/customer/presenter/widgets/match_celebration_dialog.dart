import 'package:aluga_comigo/app/modules/auth/domain/enums/user_skill.dart';
import 'package:aluga_comigo/app/modules/chats/chat_navigation.dart';
import 'package:aluga_comigo/app/modules/chats/domain/usecases/get_or_create_chat_for_contact.dart';
import 'package:aluga_comigo/app/modules/customer/data/models/customer_model.dart';
import 'package:aluga_comigo/app/modules/customer/domain/entities/mutual_match.dart';
import 'package:aluga_comigo/app/modules/customer/presenter/widgets/house_flip_card.dart';
import 'package:aluga_comigo/app/modules/customer/presenter/widgets/person_flip_card.dart';
import 'package:aluga_comigo/app/shared/domain/extends/string.dart';
import 'package:aluga_comigo/app/shared/presenter/helpers/incomplete_profile_helper.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

class MatchCelebrationDialog extends StatelessWidget {
  final MutualMatch mutualMatch;

  const MatchCelebrationDialog({super.key, required this.mutualMatch});

  static Future<void> show(BuildContext context, MutualMatch mutualMatch) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => MatchCelebrationDialog(mutualMatch: mutualMatch),
    );
  }

  int _calculateAge(String dateBirth) {
    if (dateBirth.isEmpty) return 0;
    final date = dateBirth.toDate();
    if (date == null) return 0;
    final now = DateTime.now();
    var age = now.year - date.year;
    if (now.month < date.month ||
        (now.month == date.month && now.day < date.day)) {
      age--;
    }
    return age;
  }

  String _getSkillName(UserSkill skill) {
    return switch (skill) {
      UserSkill.cucaMaster => 'Mestre cuca',
      UserSkill.ninjaInSweeping => 'Ninja na vassoura',
      UserSkill.humanDishwasher => 'Lava-louças humano',
      UserSkill.laundryOperator => 'Operador de lavanderia',
      UserSkill.none => '',
    };
  }

  Future<bool> _onVerMais(
    BuildContext context,
    FlipCardController flipController,
  ) async {
    if (!await IncompleteProfileHelper.canShowDetails(context)) {
      return false;
    }
    flipController.toggleCard();
    return true;
  }

  Future<void> _startChat(BuildContext context) async {
    final getOrCreateChat = inject<IGetOrCreateChatForContact>();
    final chat = await getOrCreateChat(mutualMatch.matchedCustomer);
    if (!context.mounted) return;

    if (chat == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Match confirmado! A conversa abrirá assim que o chat estiver disponível.',
          ),
        ),
      );
      return;
    }

    Navigator.of(context).pop();
    await ChatNavigation.open(context, chat);
  }

  @override
  Widget build(BuildContext context) {
    final customer = mutualMatch.matchedCustomer;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.52;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Material(
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFFF3E0), Colors.white],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Gap(16),
              Text(
                'É um match!',
                style: GoogleFonts.rubik(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFDF924B),
                ),
              ),
              const Gap(4),
              Text(
                'Vocês curtiram um ao outro',
                style: GoogleFonts.rubik(fontSize: 14, color: Colors.black54),
              ),
              const Gap(12),
              SizedBox(
                height: maxHeight,
                width: double.infinity,
                child: switch (customer) {
                  PersonCustomerModel person => PersonFlipCard(
                    customer: person,
                    calculateAge: _calculateAge,
                    getSkillName: _getSkillName,
                    height: maxHeight,
                    onVerMaisPressed: (c) => _onVerMais(context, c),
                  ),
                  ImmobileCustomerModel immobile => HouseFlipCard(
                    immobile: immobile,
                    height: maxHeight,
                    onVerMaisPressed: (c) => _onVerMais(context, c),
                  ),
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Fechar'),
                      ),
                    ),
                    const Gap(12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => _startChat(context),
                        child: const Text('Iniciar chat'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
