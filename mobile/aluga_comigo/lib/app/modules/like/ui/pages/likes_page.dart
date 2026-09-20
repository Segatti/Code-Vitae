import 'package:aluga_comigo/app/modules/auth/domain/enums/type_immobile.dart';
import 'package:aluga_comigo/app/modules/auth/domain/enums/type_user.dart';
import 'package:aluga_comigo/app/modules/chats/domain/entities/chat.dart';
import 'package:aluga_comigo/app/modules/chats/domain/usecases/get_or_create_chat_for_contact.dart';
import 'package:aluga_comigo/app/modules/chats/ui/widgets/immobile_listing_flip_dialog.dart';
import 'package:aluga_comigo/app/modules/customer/data/models/customer_model.dart';
import 'package:aluga_comigo/app/modules/customer/domain/enums/match_type.dart';
import 'package:aluga_comigo/app/modules/like/data/models/incoming_like_model.dart';
import 'package:aluga_comigo/app/modules/like/ui/controllers/likes_controller.dart';
import 'package:aluga_comigo/app/modules/like/ui/models/immobile_likes_group.dart';
import 'package:aluga_comigo/app/modules/like/ui/widgets/incoming_like_flip_dialog.dart';
import 'package:aluga_comigo/app/modules/like/ui/widgets/match_action_person_card.dart';
import 'package:aluga_comigo/app/shared/data/services/session_service.dart';
import 'package:aluga_comigo/app/shared/data/services/supabase_database_service.dart';
import 'package:aluga_comigo/app/shared/domain/extends/number.dart';
import 'package:aluga_comigo/app/shared/presenter/helpers/incomplete_profile_helper.dart';
import 'package:aluga_comigo/app/shared/presenter/helpers/power_up_prompt_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

import '../widgets/incoming_likes_grid.dart';

class LikesPage extends StatefulWidget {
  const LikesPage({super.key});

  @override
  State<LikesPage> createState() => _LikesPageState();
}

class _LikesPageState extends State<LikesPage> {
  late final ILikesController controller;
  String _ownerDisplayName = '';

  bool get _isImmobileOwner =>
      SessionService.customer?.typeUser == TypeUser.immobile;

  @override
  void initState() {
    super.initState();
    controller = inject<ILikesController>();
    controller.initialize();
    if (_isImmobileOwner) {
      _loadOwnerDisplayName();
    }
  }

  Future<void> _loadOwnerDisplayName() async {
    final accountId = SessionService.customer?.id ?? '';
    if (accountId.isEmpty) return;
    final database = inject<SupabaseDatabaseService>();
    final result = await database.readImmobile(accountId);
    if (!mounted) return;
    result.fold((_) {}, (map) {
      final name = map['name']?.toString().trim() ?? '';
      if (name.isNotEmpty) {
        setState(() => _ownerDisplayName = name);
      }
    });
  }

  bool _hasActivePowerUp() =>
      SessionService.customer?.hasActivePowerUp ?? false;

  /// Curtidas comuns exigem PowerUp; Super Star sempre liberado.
  bool _shouldBlurItem(IncomingLikeModel item) {
    if (_isImmobileOwner) return false;
    if (item.matchType == MatchType.favorite) return false;
    return !_hasActivePowerUp();
  }

  bool _canOpenDetails(IncomingLikeModel item) => !_shouldBlurItem(item);

  Future<Chat?> _resolveChatForPerson(IncomingLikeModel item) async {
    final person = item.customer;
    if (person is! PersonCustomerModel) return null;

    final getOrCreateChat = inject<IGetOrCreateChatForContact>();
    final chat = await getOrCreateChat(
      person,
      immobileListingId: item.immobileId,
    );
    if (!mounted) return null;

    if (chat == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir a conversa.')),
      );
    }
    return chat;
  }

  Future<void> _onItemTap(IncomingLikeModel item) async {
    if (!_canOpenDetails(item)) {
      await PowerUpPromptHelper.promptForIncomingLikes(context);
      if (mounted) setState(() {});
      return;
    }

    await IncomingLikeFlipDialog.show(
      context,
      item: item,
      forImmobileOwner: _isImmobileOwner,
      onRespond: (matchType) => controller.respondToLike(item, matchType),
      onResolveChatForConversation: _isImmobileOwner
          ? () => _resolveChatForPerson(item)
          : null,
    );
  }

  String _typeLabel(TypeImmobile type) =>
      type.title.isNotEmpty ? type.title : 'Imóvel';

  Future<void> _showImmobileFlip(ImmobileCustomerModel immobile) async {
    if (!await IncompleteProfileHelper.canShowDetails(context)) {
      return;
    }
    if (!mounted) return;
    await ImmobileListingFlipDialog.show(
      context,
      immobile,
      ownerDisplayName: _ownerDisplayName,
    );
  }

  Widget _immobileGroupHeader(ImmobileLikesGroup group) {
    final immobile = group.immobile;
    final photoUrl =
        immobile.photos.isNotEmpty ? immobile.photos.first : '';
    final typeLabel = _typeLabel(immobile.typeImmobile);

    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: photoUrl.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: photoUrl,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                )
              : Container(
                  width: 56,
                  height: 56,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.home_work_outlined),
                ),
        ),
        const Gap(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                typeLabel,
                style: GoogleFonts.rubik(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              if (immobile.price > 0)
                Text(
                  immobile.price.toMoney(),
                  style: GoogleFonts.rubik(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              Text(
                '${group.items.length} interessado(s)',
                style: GoogleFonts.rubik(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () => _showImmobileFlip(immobile),
          child: Text(
            'Ver',
            style: GoogleFonts.rubik(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  String _personName(IncomingLikeModel item) {
    return switch (item.customer) {
      PersonCustomerModel(:final name) => name,
      _ => 'Pessoa',
    };
  }

  Widget _expansionSection({
    required String title,
    required List<IncomingLikeModel> items,
  }) {
    return Container(
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
        title: Text(title, style: GoogleFonts.rubik()),
        shape: const Border(),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
        expandedAlignment: Alignment.topLeft,
        children: [
          const Divider(height: 1, thickness: 2),
          const Gap(16),
          Row(
            children: [
              Expanded(
                child: IncomingLikesGrid(
                  items: items,
                  blurForItem: _shouldBlurItem,
                  onItemTap: _onItemTap,
                ),
              ),
            ],
          ),
          const Gap(16),
        ],
      ),
    );
  }

  Widget _immobileOwnerSection(ImmobileLikesGroup group) {
    return Container(
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
        initiallyExpanded: true,
        title: _immobileGroupHeader(group),
        shape: const Border(),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
        expandedAlignment: Alignment.topLeft,
        children: [
          const Divider(height: 1, thickness: 2),
          const Gap(16),
          if (group.items.isEmpty)
            Text(
              'Ninguém curtiu ou favoritou este imóvel ainda.',
              style: GoogleFonts.rubik(color: Colors.black54),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                return Wrap(
                  spacing: constraints.maxWidth * .1 / 2,
                  runSpacing: 16,
                  children: [
                    for (final item in group.items)
                      MatchActionPersonCard(
                        title: _personName(item),
                        photoUrl: item.customer.photos.isNotEmpty
                            ? item.customer.photos.first
                            : '',
                        matchType: item.matchType,
                        width: constraints.maxWidth * .3,
                        onTap: () => _onItemTap(item),
                      ),
                  ],
                );
              },
            ),
          const Gap(16),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        if (controller.loadingList.contains('loadLikes')) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty && controller.items.isEmpty) {
          return Center(child: Text(controller.errorMessage));
        }

        if (_isImmobileOwner) {
          final groups = controller.immobileLikeGroups;
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Text(
                    'Pessoas que curtiram ou favoritaram seus imóveis',
                    style: GoogleFonts.rubik(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ),
                const Gap(12),
                if (groups.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      'Nenhuma curtida ou favorito ainda.',
                      style: GoogleFonts.rubik(color: Colors.black54),
                    ),
                  )
                else
                  ...groups.map(
                    (group) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _immobileOwnerSection(group),
                    ),
                  ),
                const Gap(90),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              _expansionSection(
                title: 'Super Star(${controller.superStars.length})',
                items: controller.superStars,
              ),
              const Gap(16),
              _expansionSection(
                title: 'Curtidas(${controller.likes.length})',
                items: controller.likes,
              ),
              const Gap(90),
            ],
          ),
        );
      },
    );
  }
}
