import 'package:aluga_comigo/app/modules/auth/domain/enums/user_skill.dart';
import 'package:aluga_comigo/app/modules/customer/data/models/customer_model.dart';
import 'package:aluga_comigo/app/modules/customer/domain/enums/match_type.dart';
import 'package:aluga_comigo/app/modules/customer/domain/usecases/match_customer.dart';
import 'package:aluga_comigo/app/modules/customer/domain/usecases/match_immobile_with_super_chat.dart';
import 'package:aluga_comigo/app/modules/house/ui/widgets/super_chat_immobile_dialog.dart';
import 'package:aluga_comigo/app/modules/customer/presenter/widgets/house_flip_card.dart';
import 'package:aluga_comigo/app/modules/customer/presenter/widgets/match_celebration_dialog.dart';
import 'package:aluga_comigo/app/modules/customer/presenter/widgets/person_flip_card.dart';
import 'package:aluga_comigo/app/modules/like/data/models/rejected_history_item.dart';
import 'package:aluga_comigo/app/shared/data/services/session_service.dart';
import 'package:aluga_comigo/app/shared/domain/constants/icons_asset.dart';
import 'package:aluga_comigo/app/shared/domain/extends/string.dart';
import 'package:aluga_comigo/app/shared/domain/helpers/maps_helper.dart';
import 'package:aluga_comigo/app/shared/presenter/helpers/incomplete_profile_helper.dart';
import 'package:aluga_comigo/app/shared/presenter/helpers/inventory_prompt_helper.dart';
import 'package:aluga_comigo/app/shared/presenter/widgets/feed_super_star_action_icon.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

class HistoryFlipDialog extends StatefulWidget {
  final RejectedHistoryItem item;

  const HistoryFlipDialog({super.key, required this.item});

  static Future<bool?> show(BuildContext context, RejectedHistoryItem item) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (_) => HistoryFlipDialog(item: item),
    );
  }

  @override
  State<HistoryFlipDialog> createState() => _HistoryFlipDialogState();
}

class _HistoryFlipDialogState extends State<HistoryFlipDialog> {
  late final IMatchCustomer _matchCustomer;
  late final IMatchImmobileWithSuperChat _matchImmobileWithSuperChat;
  bool _submitting = false;
  late MatchType _currentMatchType;

  @override
  void initState() {
    super.initState();
    _matchCustomer = inject<IMatchCustomer>();
    _matchImmobileWithSuperChat = inject<IMatchImmobileWithSuperChat>();
    _currentMatchType = widget.item.matchType;
  }

  bool get _hasActivePowerUp =>
      SessionService.customer?.hasActivePowerUp ?? false;

  bool get _isLikedOrFavorite =>
      _currentMatchType == MatchType.like ||
      _currentMatchType == MatchType.favorite;

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

  Future<bool> _checkProfileAndShowDetails(
    FlipCardController flipController,
  ) async {
    if (!await IncompleteProfileHelper.canShowDetails(context)) {
      return false;
    }
    flipController.toggleCard();
    return true;
  }

  Future<void> _promptPowerUpPurchase() async {
    final goToStore = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'PowerUp necessário',
          style: GoogleFonts.rubik(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Para mudar sua opinião no histórico, você precisa de um PowerUp '
          'ativo. Deseja ir à loja?',
          style: GoogleFonts.rubik(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Agora não'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Ir para a loja'),
          ),
        ],
      ),
    );

    if (!mounted || goToStore != true) return;

    Navigator.of(context).pop(false);
    if (context.mounted) {
      context.pushNamed('/store/');
    }
  }

  Future<void> _onMatchAction(MatchType matchType) async {
    if (!_hasActivePowerUp) {
      await _promptPowerUpPurchase();
      return;
    }

    if (_submitting) return;

    final customer = widget.item.customer;
    if (matchType == MatchType.favorite && customer is ImmobileCustomerModel) {
      if (!await InventoryPromptHelper.ensureSuperChatAvailable(context)) {
        return;
      }
      if (!mounted) return;
      final message = await SuperChatImmobileDialog.show(context);
      if (message == null || !mounted) return;
      setState(() => _submitting = true);
      final result = await _matchImmobileWithSuperChat(
        immobile: customer,
        message: message,
      );
      if (!mounted) return;
      setState(() => _submitting = false);
      result.fold(
        (response) async {
          Navigator.of(context).pop(true);
          final mutual = response.mutualMatch;
          if (mutual != null && context.mounted) {
            await MatchCelebrationDialog.show(context, mutual);
          }
        },
        (failure) {
          final text = failure.toString().replaceFirst('Exception: ', '');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(text.isNotEmpty ? text : 'Erro ao salvar')),
          );
        },
      );
      return;
    }

    if (InventoryPromptHelper.actionUsesSuperStar(matchType, customer) &&
        !await InventoryPromptHelper.ensureSuperStarAvailable(context)) {
      return;
    }

    setState(() => _submitting = true);

    final result = await _matchCustomer(widget.item.customer, matchType);

    if (!mounted) return;
    setState(() => _submitting = false);

    result.fold(
      (response) async {
        Navigator.of(context).pop(true);
        final mutual = response.mutualMatch;
        if (mutual != null && context.mounted) {
          await MatchCelebrationDialog.show(context, mutual);
        }
      },
      (failure) {
        final message = failure.toString().replaceFirst('Exception: ', '');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message.isNotEmpty ? message : 'Erro ao salvar'),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final customer = widget.item.customer;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.62;

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
                onPressed: () => Navigator.of(context).pop(false),
                icon: const Icon(Icons.close, color: Colors.grey),
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
                  historyOpinion: _currentMatchType,
                  onVerMaisPressed: _checkProfileAndShowDetails,
                ),
                ImmobileCustomerModel immobile => HouseFlipCard(
                  immobile: immobile,
                  height: maxHeight,
                  historyOpinion: _currentMatchType,
                  onVerMaisPressed: _checkProfileAndShowDetails,
                  onVerNoMapaPressed: () {
                    MapsHelper.openLocation(
                      cep: immobile.cep,
                      cityState: immobile.cityState,
                    );
                  },
                ),
              },
            ),
            const Gap(12),
            if (_isLikedOrFavorite)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GestureDetector(
                  onTap: _submitting
                      ? null
                      : () => _onMatchAction(MatchType.unlike),
                  child: _actionButton(
                    borderRadius: BorderRadius.circular(50),
                    asset: IconsAsset.unlike,
                    label: 'Não gostei',
                  ),
                ),
              )
            else
              Row(
                children: [
                  const Gap(16),
                  Expanded(
                    child: GestureDetector(
                      onTap: _submitting
                          ? null
                          : () => _onMatchAction(MatchType.favorite),
                      child: _actionButton(
                        key: const ValueKey('history_super_star_action'),
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(50),
                          right: Radius.circular(20),
                        ),
                        icon: FeedSuperStarActionIcon(
                          target: widget.item.customer,
                        ),
                      ),
                    ),
                  ),
                  const Gap(16),
                  Expanded(
                    child: GestureDetector(
                      onTap: _submitting
                          ? null
                          : () => _onMatchAction(MatchType.like),
                      child: _actionButton(
                        borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(20),
                          right: Radius.circular(50),
                        ),
                        asset: IconsAsset.like,
                      ),
                    ),
                  ),
                  const Gap(16),
                ],
              ),
            if (_submitting)
              const Padding(
                padding: EdgeInsets.only(top: 8, bottom: 16),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            else
              const Gap(16),
          ],
        ),
      ),
    );
  }

  Widget _actionButton({
    Key? key,
    required BorderRadius borderRadius,
    String? asset,
    Widget? icon,
    String? label,
  }) {
    assert(asset != null || icon != null);

    final iconWidget = icon ??
        Image.asset(
          asset!,
          width: 45,
          height: 45,
        );

    return Container(
      key: key,
      decoration: BoxDecoration(
        boxShadow: const [
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
        borderRadius: borderRadius,
      ),
      height: 60,
      padding: const EdgeInsets.all(8),
      child: label == null
          ? Center(child: iconWidget)
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                iconWidget,
                const Gap(12),
                Text(
                  label,
                  style: GoogleFonts.rubik(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
    );
  }
}
