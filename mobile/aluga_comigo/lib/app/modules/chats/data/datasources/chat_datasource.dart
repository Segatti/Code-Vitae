import '../../../../shared/data/datasources/account_block_datasource.dart';
import '../../../../shared/data/services/session_service.dart';
import '../../../../shared/data/services/supabase_database_service.dart';
import '../../../../shared/data/services/supabase_realtime_service.dart';
import '../../../../shared/domain/usecases/list_blocked_account_ids.dart';
import '../../../customer/data/models/customer_model.dart';
import '../../domain/entities/chat.dart';
import '../models/chat_immobile_offer_model.dart';
import '../models/chat_message_model.dart';
import '../models/chat_model.dart';

abstract interface class IChatDatasource {
  Future<ChatModel?> getChatById(String chatId);
  Future<List<ChatModel>> listChats();
  Future<List<ChatMessageModel>> listMessages(
    String chatId, {
    required bool isPersonPeerChat,
  });
  Future<ChatMessageModel> sendMessage({
    required String chatId,
    required String content,
    required bool isPersonPeerChat,
  });
  Future<ChatMessageModel> sendSuperChatMessage({
    required String chatId,
    required String content,
  });

  Stream<List<ChatModel>> watchChats();

  Stream<List<ChatMessageModel>> watchMessages(
    String chatId, {
    required bool isPersonPeerChat,
  });

  Future<void> deleteChat(Chat chat);

  Future<ImmobileCustomerModel> getImmobileListing(String listingId);
  Future<List<ChatImmobileOfferModel>> listImmobileOffers(String chatId);
  Future<ChatImmobileOfferModel> offerImmobileInChat({
    required String chatId,
    required String immobileListingId,
  });
}

class ChatDatasource implements IChatDatasource {
  final SupabaseDatabaseService database;
  final SupabaseRealtimeService realtime;
  final IListBlockedAccountIds listBlockedAccountIds;
  final IAccountBlockDatasource accountBlockDatasource;

  const ChatDatasource(
    this.database,
    this.realtime,
    this.listBlockedAccountIds,
    this.accountBlockDatasource,
  );

  Future<Set<String>> _blockedIds() async {
    final result = await listBlockedAccountIds();
    return result.fold((ids) => ids.toSet(), (_) => <String>{});
  }

  Future<void> _ensureNotBlockedWithChat(String chatId) async {
    final userId = SessionService.customer!.id;
    final row = await database.findChatForUser(userId, chatId);
    if (row == null) {
      throw Exception('Conversa não encontrada');
    }
    final chat = ChatModel.fromMap(row);
    final otherId = chat.toEntity().otherParticipantAccountId(userId);
    final blocked = await accountBlockDatasource.isBlockedEitherWay(
      accountId: userId,
      otherAccountId: otherId,
    );
    if (blocked) {
      throw Exception('Você não pode interagir com este contato.');
    }
  }

  @override
  Future<ChatModel?> getChatById(String chatId) async {
    final userId = SessionService.customer!.id;
    final row = await database.findChatForUser(userId, chatId);
    if (row == null) return null;
    return ChatModel.fromMap(row);
  }

  @override
  Future<List<ChatModel>> listChats() async {
    final userId = SessionService.customer!.id;
    final rows = await database.listChatsForUser(userId);
    final blocked = await _blockedIds();
    return rows
        .map<ChatModel>(ChatModel.fromMap)
        .where((chat) {
          final otherId = chat.toEntity().otherParticipantAccountId(userId);
          return !blocked.contains(otherId);
        })
        .toList();
  }

  @override
  Future<List<ChatMessageModel>> listMessages(
    String chatId, {
    required bool isPersonPeerChat,
  }) async {
    await database.markChatMessagesRead(chatId);
    final rows = await database.listMessages(
      chatId,
      personPeerChat: isPersonPeerChat,
    );
    return rows.map<ChatMessageModel>(ChatMessageModel.fromMap).toList();
  }

  @override
  Future<ChatMessageModel> sendMessage({
    required String chatId,
    required String content,
    required bool isPersonPeerChat,
  }) async {
    await _ensureNotBlockedWithChat(chatId);
    final senderId = SessionService.customer!.id;
    final row = await database.sendMessage(
      chatId: chatId,
      senderId: senderId,
      content: content,
      personPeerChat: isPersonPeerChat,
    );
    return ChatMessageModel.fromMap(row);
  }

  @override
  Future<ChatMessageModel> sendSuperChatMessage({
    required String chatId,
    required String content,
  }) async {
    await _ensureNotBlockedWithChat(chatId);
    final consumed = await database.consumeSuperChat();
    if (!consumed) {
      throw Exception('Você não tem Super Chat. Compre na loja.');
    }
    final inventory = await database.getUserInventory();
    SessionService.setInventory(UserInventory.fromMap(inventory));

    final senderId = SessionService.customer!.id;
    final row = await database.sendMessage(
      chatId: chatId,
      senderId: senderId,
      content: content,
      messageType: 'superChat',
    );
    return ChatMessageModel.fromMap(row);
  }

  @override
  Stream<List<ChatModel>> watchChats() async* {
    yield await listChats();
    await for (final _ in realtime.watchChatInboxChanges()) {
      yield await listChats();
    }
  }

  @override
  Stream<List<ChatMessageModel>> watchMessages(
    String chatId, {
    required bool isPersonPeerChat,
  }) async* {
    yield await listMessages(chatId, isPersonPeerChat: isPersonPeerChat);
    await for (final _ in realtime.watchChatMessages(
      chatId: chatId,
      personPeerChat: isPersonPeerChat,
    )) {
      yield await listMessages(chatId, isPersonPeerChat: isPersonPeerChat);
    }
  }

  @override
  Future<void> deleteChat(Chat chat) {
    return database.deleteChatForUser(
      chatId: chat.id,
      isPersonPeerChat: chat.isPersonPeerChat,
    );
  }

  @override
  Future<ImmobileCustomerModel> getImmobileListing(String listingId) async {
    final result = await database.readImmobile(listingId);
    return result.fold(
      (_) => throw Exception('Imóvel não encontrado'),
      (row) {
        if (row.isEmpty) {
          throw Exception('Imóvel não encontrado');
        }
        final customer = CustomerModel.fromMap(row);
        if (customer is! ImmobileCustomerModel) {
          throw Exception('Imóvel não encontrado');
        }
        return customer;
      },
    );
  }

  @override
  Future<List<ChatImmobileOfferModel>> listImmobileOffers(String chatId) async {
    final rows = await database.listChatImmobileOffers(chatId);
    return rows.map(ChatImmobileOfferModel.fromMap).toList();
  }

  @override
  Future<ChatImmobileOfferModel> offerImmobileInChat({
    required String chatId,
    required String immobileListingId,
  }) async {
    final row = await database.insertChatImmobileOffer(
      chatId: chatId,
      immobileId: immobileListingId,
      offeredByAccountId: SessionService.customer!.id,
    );
    return ChatImmobileOfferModel.fromMap(row);
  }
}
