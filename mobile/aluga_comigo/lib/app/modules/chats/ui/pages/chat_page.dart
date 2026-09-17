import 'package:aluga_comigo/app/modules/auth/domain/enums/type_user.dart';
import 'package:aluga_comigo/app/modules/chats/domain/entities/chat.dart';
import 'package:aluga_comigo/app/modules/chats/domain/entities/chat_message.dart';
import 'package:aluga_comigo/app/modules/chats/domain/usecases/get_immobile_listing.dart';
import 'package:aluga_comigo/app/modules/chats/ui/controllers/chat_controller.dart';
import 'package:aluga_comigo/app/modules/chats/ui/widgets/chat_attach_action_sheet.dart';
import 'package:aluga_comigo/app/modules/chats/ui/widgets/chat_contact_flip_dialog.dart';
import 'package:aluga_comigo/app/modules/chats/ui/widgets/chat_contact_listing_banner.dart';
import 'package:aluga_comigo/app/modules/chats/ui/widgets/chat_immobile_offer_card.dart';
import 'package:aluga_comigo/app/modules/chats/ui/widgets/immobile_listing_flip_dialog.dart';
import 'package:aluga_comigo/app/modules/chats/ui/widgets/offer_immobile_picker_sheet.dart';
import 'package:aluga_comigo/app/modules/house/ui/widgets/super_chat_immobile_dialog.dart';
import 'package:aluga_comigo/app/shared/data/services/session_service.dart';
import 'package:aluga_comigo/app/shared/domain/constants/icons_asset.dart';
import 'package:aluga_comigo/app/shared/presenter/helpers/inventory_prompt_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

class ChatPage extends StatefulWidget {
  final Chat chat;

  const ChatPage({super.key, required this.chat});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  var _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    context.read<IChatController>().initialize(widget.chat);
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    return DateFormat('HH:mm').format(dateTime);
  }

  Future<void> _openListingFlip(IChatController controller) async {
    final listing = controller.contactListing;
    if (listing != null && mounted) {
      await ImmobileListingFlipDialog.show(context, listing);
      return;
    }
    if (widget.chat.contactListingId.isEmpty) return;
    final getListing = inject<IGetImmobileListing>();
    final result = await getListing(widget.chat.contactListingId);
    if (!mounted) return;
    result.fold(
      (immobile) => ImmobileListingFlipDialog.show(context, immobile),
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível carregar o imóvel')),
        );
      },
    );
  }

  Future<void> _openOfferListing(String listingId) async {
    final getListing = inject<IGetImmobileListing>();
    final result = await getListing(listingId);
    if (!mounted) return;
    result.fold(
      (immobile) => ImmobileListingFlipDialog.show(context, immobile),
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível carregar o imóvel')),
        );
      },
    );
  }

  void _showAttachSheet(IChatController controller) {
    final sessionType = SessionService.customer?.typeUser ?? TypeUser.none;
    final isImmobileAccount = sessionType == TypeUser.immobile;

    final actions = <ChatAttachAction>[
      if (isImmobileAccount)
        const ChatAttachAction(
          id: 'listing',
          label: 'Imóvel',
          icon: Icons.home_work_outlined,
          iconColor: Colors.white,
        ),
      ChatAttachAction(
        id: 'superChat',
        label: 'Super Chat',
        icon: Icons.chat,
        iconWidget: SvgPicture.asset(
          IconsAsset.chat,
          width: 28,
          height: 28,
          colorFilter: const ColorFilter.mode(Colors.amber, BlendMode.srcIn),
        ),
      ),
      if (isImmobileAccount)
        const ChatAttachAction(
          id: 'offer',
          label: 'Oferecer imóvel',
          icon: Icons.add_home_work_outlined,
          iconColor: Colors.white,
        ),
    ];

    ChatAttachActionSheet.show(
      context,
      actions: actions,
      onActionSelected: (actionId) async {
        switch (actionId) {
          case 'listing':
            await _openListingFlip(controller);
          case 'superChat':
            await _sendSuperChatFromMenu(controller);
          case 'offer':
            final picked = await OfferImmobilePickerSheet.show(
              context,
              excludeListingId: widget.chat.contactListingId,
            );
            if (picked == null || !mounted) return;
            final ok = await controller.offerImmobile(picked.id);
            if (!mounted) return;
            if (!ok && controller.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(controller.errorMessage!)),
              );
            }
        }
      },
    );
  }

  Future<void> _sendSuperChatFromMenu(IChatController controller) async {
    if (!await InventoryPromptHelper.ensureSuperChatAvailable(context)) {
      return;
    }
    if (!mounted) return;
    final message = await SuperChatImmobileDialog.show(
      context,
      inConversation: true,
    );
    if (message == null || !mounted) return;
    final ok = await controller.sendSuperChatMessage(message);
    if (!mounted) return;
    final error = controller.errorMessage;
    if (!ok && error != null && error.isNotEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<IChatController>();
    final messages = controller.messages;
    final isSending = controller.loadingList.contains('sendMessage');
    final isSendingSuperChat = controller.loadingList.contains('sendSuperChat');
    final isPersonImmobileChat =
        !widget.chat.isPersonPeerChat && widget.chat.contactListingId.isNotEmpty;
    final offerCount = controller.immobileOffers.length;
    final hasContactBanner = isPersonImmobileChat;
    final listExtraCount = offerCount + (hasContactBanner ? 1 : 0);
    final listing = controller.contactListing;
    final bannerTitle = listing != null && listing.shortDescription.isNotEmpty
        ? listing.shortDescription
        : widget.chat.immobileName;
    final bannerPhoto = listing?.photos.isNotEmpty == true
        ? listing!.photos.first
        : widget.chat.immobilePhoto;
    final sessionId = SessionService.customer?.id ?? '';
    final otherDisplay = sessionId.isEmpty
        ? (name: widget.chat.otherName, photo: widget.chat.otherPhoto)
        : widget.chat.otherParticipantDisplay(sessionId);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.chevron_left, size: 40, color: Colors.grey),
        ),
        titleSpacing: 0,
        title: InkWell(
          onTap: () => ChatContactFlipDialog.show(context, widget.chat),
          borderRadius: BorderRadius.circular(8),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: otherDisplay.photo.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: otherDisplay.photo,
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        height: 40,
                        width: 40,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.person),
                      ),
              ),
              const Gap(16),
              Expanded(
                child: Text(
                  otherDisplay.name,
                  style: GoogleFonts.rubik(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Gap(16),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          const Divider(height: 2, thickness: 2, color: Colors.black26),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child:
                      controller.loadingList.contains('loadMessages') &&
                          messages.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.separated(
                          reverse: true,
                          itemCount: messages.length + listExtraCount,
                          padding: const EdgeInsets.only(bottom: 100, top: 8),
                          itemBuilder: (context, index) {
                            if (index < messages.length) {
                              final reversedIndex =
                                  messages.length - 1 - index;
                              final message = messages[reversedIndex];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    return Row(
                                      mainAxisAlignment: message.isFromUser
                                          ? MainAxisAlignment.end
                                          : MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: message.isFromUser
                                          ? [
                                              Text(
                                                _formatTime(message.createdAt),
                                              ),
                                              const Gap(8),
                                              _messageBubble(
                                                message,
                                                constraints.maxWidth * .8,
                                                isUser: true,
                                              ),
                                            ]
                                          : [
                                              _messageBubble(
                                                message,
                                                constraints.maxWidth * .8,
                                                isUser: false,
                                              ),
                                              const Gap(8),
                                              Text(
                                                _formatTime(message.createdAt),
                                              ),
                                            ],
                                    );
                                  },
                                ),
                              );
                            }

                            if (index < messages.length + offerCount) {
                              final offerIndex = index - messages.length;
                              final offer =
                                  controller.immobileOffers[offerIndex];
                              return ChatImmobileOfferCard(
                                offer: offer,
                                onTap: () => _openOfferListing(
                                  offer.immobileId,
                                ),
                              );
                            }

                            return ChatContactListingBanner(
                              title: bannerTitle,
                              subtitle: 'Conversa iniciada sobre este imóvel',
                              photoUrl: bannerPhoto,
                              onTap: () => _openListingFlip(controller),
                            );
                          },
                          separatorBuilder: (_, index) {
                            if (index >= messages.length + listExtraCount - 1) {
                              return const SizedBox.shrink();
                            }
                            return const Gap(16);
                          },
                        ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.only(
                      bottom: 8,
                      top: 8,
                      right: 8,
                      left: 16,
                    ),
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
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
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: controller.messageController,
                            decoration: const InputDecoration(
                              hintText: "Mensagem",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 8),
                            ),
                            onFieldSubmitted: (_) async {
                              await controller.sendMessage();
                            },
                          ),
                        ),
                        if (isPersonImmobileChat)
                          IconButton(
                            onPressed: isSendingSuperChat
                                ? null
                                : () => _showAttachSheet(controller),
                            icon: Icon(
                              Icons.attach_file,
                              color: isSendingSuperChat
                                  ? Colors.black26
                                  : Colors.black54,
                            ),
                          ),
                        IconButton(
                          onPressed: isSending
                              ? null
                              : () async {
                                  await controller.sendMessage();
                                },
                          icon: Icon(
                            isSending ? Icons.hourglass_empty : Icons.send,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _messageBubble(
    ChatMessage message,
    double maxWidth, {
    required bool isUser,
  }) {
    if (message.isSuperChat) {
      return _superChatMessageBubble(message, maxWidth, isUser: isUser);
    }

    final borderColor = isUser ? Colors.blue : Colors.amber;

    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Text(message.content, maxLines: null, style: GoogleFonts.rubik()),
    );
  }

  Widget _superChatMessageBubble(
    ChatMessage message,
    double maxWidth, {
    required bool isUser,
  }) {
    const accent = Color(0xFFFFC850);
    const accentDark = Color(0xFFE6A800);

    return Column(
      crossAxisAlignment: isUser
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFFF9E6), Color(0xFFFFEFB8)],
            ),
            border: Border.all(color: accent, width: 2.5),
            boxShadow: const [
              BoxShadow(
                color: Color(0x40FFC850),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.35),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(13),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      IconsAsset.chat,
                      width: 22,
                      height: 22,
                      colorFilter: const ColorFilter.mode(
                        accentDark,
                        BlendMode.srcIn,
                      ),
                    ),
                    const Gap(8),
                    Text(
                      'Super Chat',
                      style: GoogleFonts.rubik(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: accentDark,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
                child: Text(
                  message.content,
                  maxLines: null,
                  style: GoogleFonts.rubik(
                    fontSize: 15,
                    height: 1.35,
                    color: Colors.black87,
                  ),
                ),
              ),
              if (isUser)
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                  child: _superChatReadReceipt(message),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _superChatReadReceipt(ChatMessage message) {
    final read = message.isReadByOther;
    final label = read ? 'Lida pelo destinatário' : 'Aguardando leitura';
    final icon = read ? Icons.done_all : Icons.schedule;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: read ? const Color(0xFF43A047) : Colors.black26,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: read ? const Color(0xFF43A047) : Colors.black54,
          ),
          const Gap(6),
          Flexible(
            child: Text(
              label,
              style: GoogleFonts.rubik(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: read ? const Color(0xFF2E7D32) : Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
