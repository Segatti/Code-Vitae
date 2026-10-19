import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:result_dart/result_dart.dart';

import '../../../customer/data/models/customer_model.dart';
import '../../domain/entities/chat.dart';
import '../../domain/entities/chat_immobile_offer.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/usecases/get_immobile_listing.dart';
import '../../domain/usecases/list_chat_immobile_offers.dart';
import '../../domain/usecases/list_messages.dart';
import '../../domain/usecases/offer_immobile_in_chat.dart';
import '../../domain/usecases/send_message.dart';
import '../../domain/usecases/send_super_chat_message.dart';
import '../../domain/usecases/watch_messages.dart';
import '../../presenter/active_chat_session.dart';
import '../../../../shared/data/services/analytics_service.dart';
import '../../../../shared/domain/analytics/analytics_events.dart';
import '../../../../shared/presenter/lifecycle/app_lifecycle_bridge.dart';

abstract interface class IChatController extends ChangeNotifier {
  String? errorMessage;
  List<String> loadingList = [];
  List<ChatMessage> messages = [];
  ImmobileCustomerModel? contactListing;
  List<ChatImmobileOffer> immobileOffers = [];
  final TextEditingController messageController = TextEditingController();

  Future<Unit> initialize(Chat chat);
  Future<bool> loadMessages();
  Future<void> loadChatContext();
  Future<bool> offerImmobile(String listingId);
  Future<bool> sendMessage();
  Future<bool> sendSuperChatMessage(String content);
  @override
  void dispose();
}

class ChatController extends IChatController {
  final IListMessages _listMessages;
  final ISendMessage _sendMessage;
  final ISendSuperChatMessage _sendSuperChatMessage;
  final IWatchMessages _watchMessages;
  final IGetImmobileListing _getImmobileListing;
  final IListChatImmobileOffers _listChatImmobileOffers;
  final IOfferImmobileInChat _offerImmobileInChat;

  final IAnalyticsService _analytics;

  ChatController(
    this._listMessages,
    this._sendMessage,
    this._sendSuperChatMessage,
    this._watchMessages,
    this._getImmobileListing,
    this._listChatImmobileOffers,
    this._offerImmobileInChat,
    this._analytics,
  );

  Chat? _chat;
  StreamSubscription<List<ChatMessage>>? _messagesSubscription;

  @override
  Future<Unit> initialize(Chat chat) async {
    AppLifecycleBridge.removeResumeListener(_onAppResume);
    await _messagesSubscription?.cancel();
    _messagesSubscription = null;
    _chat = chat;
    ActiveChatSession.setOpenChat(chat.id);
    AppLifecycleBridge.addResumeListener(_onAppResume);
    messages = [];
    contactListing = null;
    immobileOffers = [];
    errorMessage = null;
    loadingList = [];
    await loadMessages();
    unawaited(loadChatContext());

    unawaited(
      _analytics.logEvent(
        AnalyticsEvents.chatOpen,
        parameters: {AnalyticsParams.chatId: chat.id},
      ),
    );

    _messagesSubscription = _watchMessages(
      chat.id,
      isPersonPeerChat: chat.isPersonPeerChat,
    ).listen(
      (list) {
        messages = list;
        errorMessage = null;
        notifyListeners();
      },
      onError: (_) {
        errorMessage = 'Erro ao atualizar mensagens';
        notifyListeners();
      },
    );

    return unit;
  }

  void _onAppResume() {
    unawaited(loadMessages());
  }

  @override
  Future<void> loadChatContext() async {
    final chat = _chat;
    if (chat == null || chat.isPersonPeerChat || chat.contactListingId.isEmpty) {
      return;
    }

    loadingList.add('chatContext');
    notifyListeners();

    final listingResult = await _getImmobileListing(chat.contactListingId);
    final offersResult = await _listChatImmobileOffers(chat.id);

    loadingList.remove('chatContext');

    listingResult.fold(
      (listing) => contactListing = listing,
      (_) => contactListing = null,
    );
    offersResult.fold(
      (offers) => immobileOffers = offers,
      (_) {},
    );
    notifyListeners();
  }

  @override
  Future<bool> offerImmobile(String listingId) async {
    final chat = _chat;
    if (chat == null || listingId.isEmpty) return false;

    loadingList.add('offerImmobile');
    notifyListeners();

    final result = await _offerImmobileInChat(
      chatId: chat.id,
      immobileListingId: listingId,
    );

    loadingList.remove('offerImmobile');

    return result.fold(
      (offer) {
        if (!immobileOffers.any((o) => o.immobileId == offer.immobileId)) {
          immobileOffers = [...immobileOffers, offer];
        }
        errorMessage = null;
        notifyListeners();
        return true;
      },
      (_) {
        errorMessage = 'Erro ao oferecer imóvel';
        notifyListeners();
        return false;
      },
    );
  }

  @override
  Future<bool> loadMessages() async {
    final chat = _chat;
    if (chat == null) return false;

    loadingList.add('loadMessages');
    notifyListeners();

    final result = await _listMessages(
      chat.id,
      isPersonPeerChat: chat.isPersonPeerChat,
    );

    loadingList.remove('loadMessages');

    return result.fold(
      (list) {
        messages = list;
        errorMessage = null;
        notifyListeners();
        return true;
      },
      (_) {
        errorMessage = 'Erro ao carregar mensagens';
        notifyListeners();
        return false;
      },
    );
  }

  @override
  Future<bool> sendMessage() async {
    final chat = _chat;
    if (chat == null) return false;

    final content = messageController.text;
    if (content.trim().isEmpty) return false;

    loadingList.add('sendMessage');
    notifyListeners();

    final result = await _sendMessage(
      chat.id,
      content,
      isPersonPeerChat: chat.isPersonPeerChat,
    );

    loadingList.remove('sendMessage');

    return result.fold(
      (message) {
        messages = [...messages, message];
        messageController.clear();
        errorMessage = null;
        notifyListeners();
        unawaited(
          _analytics.logEvent(
            AnalyticsEvents.chatMessageSent,
            parameters: {
              AnalyticsParams.chatId: chat.id,
              AnalyticsParams.messageType: 'text',
            },
          ),
        );
        return true;
      },
      (_) {
        errorMessage = 'Erro ao enviar mensagem';
        notifyListeners();
        return false;
      },
    );
  }

  @override
  Future<bool> sendSuperChatMessage(String content) async {
    final chat = _chat;
    if (chat == null) return false;

    loadingList.add('sendSuperChat');
    notifyListeners();

    final result = await _sendSuperChatMessage(
      chat.id,
      content,
      isPersonPeerChat: chat.isPersonPeerChat,
    );

    loadingList.remove('sendSuperChat');

    return result.fold(
      (message) {
        messages = [...messages, message];
        errorMessage = null;
        notifyListeners();
        unawaited(
          _analytics.logEvent(
            AnalyticsEvents.chatMessageSent,
            parameters: {
              AnalyticsParams.chatId: chat.id,
              AnalyticsParams.messageType: 'super_chat',
            },
          ),
        );
        return true;
      },
      (failure) {
        final text = failure.toString().replaceFirst('Exception: ', '');
        errorMessage = text.isNotEmpty ? text : 'Erro ao enviar Super Chat';
        notifyListeners();
        return false;
      },
    );
  }

  @override
  void dispose() {
    AppLifecycleBridge.removeResumeListener(_onAppResume);
    if (ActiveChatSession.openChatId == _chat?.id) {
      ActiveChatSession.setOpenChat(null);
    }
    unawaited(_messagesSubscription?.cancel());
    _messagesSubscription = null;
    messageController.dispose();
    super.dispose();
  }
}
