import 'package:aluga_comigo/app/modules/auth/domain/enums/user_skill.dart';
import 'package:aluga_comigo/app/modules/chats/domain/entities/chat.dart';
import 'package:aluga_comigo/app/modules/chats/domain/usecases/get_chat_contact_profile.dart';
import 'package:aluga_comigo/app/modules/chats/domain/usecases/unmatch_chat_contact.dart';
import 'package:aluga_comigo/app/modules/customer/data/models/customer_model.dart';
import 'package:aluga_comigo/app/modules/customer/presenter/widgets/house_flip_card.dart';
import 'package:aluga_comigo/app/modules/customer/presenter/widgets/person_flip_card.dart';
import 'package:aluga_comigo/app/shared/data/services/session_service.dart';
import 'package:aluga_comigo/app/shared/domain/extends/string.dart';
import 'package:aluga_comigo/app/shared/domain/helpers/maps_helper.dart';
import 'package:aluga_comigo/app/shared/presenter/helpers/incomplete_profile_helper.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

class ChatContactFlipDialog extends StatefulWidget {
  final Chat chat;

  const ChatContactFlipDialog({super.key, required this.chat});

  static Future<void> show(BuildContext context, Chat chat) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) => ChatContactFlipDialog(chat: chat),
    );
  }

  @override
  State<ChatContactFlipDialog> createState() => _ChatContactFlipDialogState();
}

class _ChatContactFlipDialogState extends State<ChatContactFlipDialog> {
  late final IGetChatContactProfile _getChatContactProfile;
  late final IUnmatchChatContact _unmatchChatContact;
  CustomerModel? _customer;
  var _loading = true;
  var _unmatching = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _getChatContactProfile = inject<IGetChatContactProfile>();
    _unmatchChatContact = inject<IUnmatchChatContact>();
    _loadContact();
  }

  Future<void> _onUnmatch() async {
    final customer = _customer;
    if (customer == null || _unmatching) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Desfazer match?'),
        content: const Text(
          'Você deixará de ser match com este contato e a conversa '
          'será removida da lista.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Desfazer match'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _unmatching = true);

    final result = await _unmatchChatContact(
      contact: customer,
      chat: widget.chat,
    );

    if (!mounted) return;
    setState(() => _unmatching = false);

    result.fold(
      (_) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Match desfeito')),
        );
      },
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao desfazer match')),
        );
      },
    );
  }

  String _otherAccountId() {
    final session = SessionService.customer;
    if (session == null) return '';
    return widget.chat.otherParticipantAccountId(session.id);
  }

  Future<void> _loadContact() async {
    final accountId = _otherAccountId();
    final result = await _getChatContactProfile(accountId);
    if (!mounted) return;

    result.fold(
      (customer) {
        setState(() {
          _customer = customer;
          _loading = false;
          _errorMessage = null;
        });
      },
      (_) {
        setState(() {
          _loading = false;
          _errorMessage = 'Não foi possível carregar o perfil';
        });
      },
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

  Future<bool> _onVerMais(FlipCardController flipController) async {
    if (!await IncompleteProfileHelper.canShowDetails(context)) {
      return false;
    }
    flipController.toggleCard();
    return true;
  }

  @override
  Widget build(BuildContext context) {
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
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, color: Colors.grey),
              ),
            ),
            if (_loading)
              SizedBox(
                height: maxHeight,
                child: const Center(child: CircularProgressIndicator()),
              )
            else if (_errorMessage != null)
              SizedBox(
                height: maxHeight * 0.4,
                child: Center(
                  child: Text(
                    _errorMessage!,
                    style: GoogleFonts.rubik(color: Colors.black54),
                  ),
                ),
              )
            else
              SizedBox(
                height: maxHeight,
                width: double.infinity,
                child: switch (_customer!) {
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
            if (!_loading && _errorMessage == null && _customer != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _unmatching ? null : _onUnmatch,
                    child: _unmatching
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Desfazer match'),
                  ),
                ),
              )
            else
              const Gap(12),
          ],
        ),
      ),
    );
  }
}
