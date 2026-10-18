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
    final result = await database.readAccount(accountId);
    if (!mounted) return;
    result.fold((_) {}, (map) {
      final name = map['contact_name']?.toString().trim() ?? '';
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
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
                    color: const Color(0xFF2C29A3),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              Text(
                '${group.items.length} interessado(s)',
                style: GoogleFonts.rubik(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ),
        Material(
          color: const Color(0xFF2C29A3),
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            onTap: () => _showImmobileFlip(immobile),
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Text(
                'Ver',
                style: GoogleFonts.rubik(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _sectionHeader({
    required String title,
    required int count,
    required IconData icon,
    required Color accent,
  }) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: accent, size: 24),
        ),
        const Gap(12),
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.rubik(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        Container(
          constraints: const BoxConstraints(minWidth: 32),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            '$count',
            textAlign: TextAlign.center,
            style: GoogleFonts.rubik(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: accent,
            ),
          ),
        ),
      ],
    );
  }

  Widget _likesExpansionCard({
    required Widget header,
    required List<Widget> children,
    bool initiallyExpanded = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
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
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.black12,
        ),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          expandedAlignment: Alignment.topLeft,
          shape: const Border(),
          collapsedShape: const Border(),
          iconColor: const Color(0xFF2C29A3),
          collapsedIconColor: Colors.black45,
          title: header,
          children: [
            const Divider(height: 1, thickness: 1, color: Color(0xFFE8E8E8)),
            const Gap(16),
            ...children,
          ],
        ),
      ),
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
    required int count,
    required IconData icon,
    required Color accent,
    required List<IncomingLikeModel> items,
  }) {
    return _likesExpansionCard(
      header: _sectionHeader(
        title: title,
        count: count,
        icon: icon,
        accent: accent,
      ),
      children: [
        IncomingLikesGrid(
          items: items,
          blurForItem: _shouldBlurItem,
          onItemTap: _onItemTap,
        ),
      ],
    );
  }

  Widget _immobileOwnerSection(ImmobileLikesGroup group) {
    return _likesExpansionCard(
      initiallyExpanded: true,
      header: _immobileGroupHeader(group),
      children: [
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
      ],
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
                const Gap(100),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Text(
                  'Quem te deu Super Star ou curtiu seu perfil',
                  style: GoogleFonts.rubik(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ),
              const Gap(12),
              _expansionSection(
                title: 'Super Star',
                count: controller.superStars.length,
                icon: Icons.star_rounded,
                accent: const Color(0xFFFFC850),
                items: controller.superStars,
              ),
              const Gap(16),
              _expansionSection(
                title: 'Curtidas',
                count: controller.likes.length,
                icon: Icons.favorite_rounded,
                accent: const Color(0xFF2C29A3),
                items: controller.likes,
              ),
              const Gap(100),
            ],
          ),
        );
      },
    );
  }
}
