import 'package:aluga_comigo/app/modules/auth/domain/enums/user_skill.dart';
import 'package:aluga_comigo/app/modules/customer/data/models/customer_model.dart';
import 'package:aluga_comigo/app/modules/customer/domain/entities/swipe_action_result.dart';
import 'package:aluga_comigo/app/modules/customer/domain/enums/match_type.dart';
import 'package:aluga_comigo/app/modules/customer/presenter/widgets/house_flip_card.dart';
import 'package:aluga_comigo/app/modules/customer/presenter/widgets/match_celebration_dialog.dart';
import 'package:aluga_comigo/app/modules/customer/presenter/widgets/person_flip_card.dart';
import 'package:aluga_comigo/app/modules/like/data/models/incoming_like_model.dart';
import 'package:aluga_comigo/app/shared/domain/extends/string.dart';
import 'package:aluga_comigo/app/shared/domain/helpers/maps_helper.dart';
import 'package:aluga_comigo/app/shared/presenter/helpers/incomplete_profile_helper.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

class IncomingLikeFlipDialog extends StatefulWidget {
  final IncomingLikeModel item;
  final Future<SwipeActionResult> Function(MatchType matchType) onRespond;
  final bool forImmobileOwner;
  final Future<void> Function()? onStartConversation;

  const IncomingLikeFlipDialog({
    super.key,
    required this.item,
    required this.onRespond,
    this.forImmobileOwner = false,
    this.onStartConversation,
  });

  static Future<void> show(
    BuildContext context, {
    required IncomingLikeModel item,
    required Future<SwipeActionResult> Function(MatchType matchType) onRespond,
    bool forImmobileOwner = false,
    Future<void> Function()? onStartConversation,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) => IncomingLikeFlipDialog(
        item: item,
        onRespond: onRespond,
        forImmobileOwner: forImmobileOwner,
        onStartConversation: onStartConversation,
      ),
    );
  }

  @override
  State<IncomingLikeFlipDialog> createState() => _IncomingLikeFlipDialogState();
}

class _IncomingLikeFlipDialogState extends State<IncomingLikeFlipDialog> {
  var _submitting = false;

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

  Future<bool> _onVerMais(FlipCardController flipController) async {
    if (!await IncompleteProfileHelper.canShowDetails(context)) {
      return false;
    }
    flipController.toggleCard();
    return true;
  }

  Future<void> _onMatch() async {
    if (_submitting) return;
    setState(() => _submitting = true);

    final result = await widget.onRespond(MatchType.like);

    if (!mounted) return;
    setState(() => _submitting = false);

    if (!result.removed) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Erro ao dar match')));
      return;
    }

    Navigator.of(context).pop();
    final mutual = result.mutualMatch;
    if (mutual != null && context.mounted) {
      await MatchCelebrationDialog.show(context, mutual);
    }
  }

  Future<void> _onStartConversation() async {
    final startConversation = widget.onStartConversation;
    if (startConversation == null || _submitting) return;
    setState(() => _submitting = true);

    try {
      await startConversation();
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final customer = widget.item.customer;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.62;
    final isSuperStar = widget.item.matchType == MatchType.favorite;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: _submitting
                    ? null
                    : () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, color: Colors.grey),
              ),
            ),
            if (isSuperStar)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'Super Star',
                  style: GoogleFonts.rubik(
                    fontWeight: FontWeight.w600,
                    color: Colors.amber.shade800,
                  ),
                ),
              ),
            SizedBox(
              height: maxHeight,
              width: double.infinity,
              child: switch (customer) {
                PersonCustomerModel person => PersonFlipCard(
                  customer: person,
                  calculateAge: _calculateAge,
                  getSkillName: _getSkillName,
                  height: maxHeight,
                  onVerMaisPressed: _onVerMais,
                ),
                ImmobileCustomerModel immobile => HouseFlipCard(
                  immobile: immobile,
                  height: maxHeight,
                  onVerMaisPressed: _onVerMais,
                  onVerNoMapaPressed: () {
                    MapsHelper.openLocation(
                      cep: immobile.cep,
                      cityState: immobile.cityState,
                    );
                  },
                ),
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _submitting
                          ? null
                          : () => Navigator.of(context).pop(),
                      child: const Text('Fechar'),
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: FilledButton(
                      onPressed: _submitting
                          ? null
                          : widget.forImmobileOwner
                          ? _onStartConversation
                          : _onMatch,
                      child: _submitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              widget.forImmobileOwner
                                  ? 'Iniciar conversa'
                                  : 'Dar match',
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
