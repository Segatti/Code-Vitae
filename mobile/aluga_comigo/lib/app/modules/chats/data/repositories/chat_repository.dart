import 'package:aluga_comigo/app/shared/domain/extends/result.dart';
import 'package:result_dart/result_dart.dart'
    hide FutureResultExtension, FutureResultExtensionVoid;

import '../../../customer/data/models/customer_model.dart';
import '../../domain/entities/chat.dart';
import '../../domain/entities/chat_immobile_offer.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart' as domain;
import '../datasources/chat_datasource.dart';

class ChatRepository implements domain.IChatRepository {
  final IChatDatasource datasource;

  const ChatRepository(this.datasource);

  @override
  AsyncResult<List<Chat>> listChats() async {
    return datasource
        .listChats()
        .then((models) => models.map((m) => m.toEntity()).toList())
        .toAsyncResult();
  }

  @override
  AsyncResult<List<ChatMessage>> listMessages(
    String chatId, {
    required bool isPersonPeerChat,
  }) async {
    return datasource
        .listMessages(chatId, isPersonPeerChat: isPersonPeerChat)
        .then((models) => models.map((m) => m.toEntity()).toList())
        .toAsyncResult();
  }

  @override
  AsyncResult<ChatMessage> sendMessage({
    required String chatId,
    required String content,
    required bool isPersonPeerChat,
  }) async {
    return datasource
        .sendMessage(
          chatId: chatId,
          content: content,
          isPersonPeerChat: isPersonPeerChat,
        )
        .then((model) => model.toEntity())
        .toAsyncResult();
  }

  @override
  AsyncResult<ChatMessage> sendSuperChatMessage({
    required String chatId,
    required String content,
  }) async {
    return datasource
        .sendSuperChatMessage(chatId: chatId, content: content)
        .then((model) => model.toEntity())
        .toAsyncResult();
  }

  @override
  AsyncResult<ImmobileCustomerModel> getImmobileListing(String listingId) async {
    return datasource
        .getImmobileListing(listingId)
        .toAsyncResult();
  }

  @override
  AsyncResult<List<ChatImmobileOffer>> listImmobileOffers(String chatId) async {
    return datasource
        .listImmobileOffers(chatId)
        .then((models) => models.map((m) => m.toEntity()).toList())
        .toAsyncResult();
  }

  @override
  AsyncResult<ChatImmobileOffer> offerImmobileInChat({
    required String chatId,
    required String immobileListingId,
  }) async {
    return datasource
        .offerImmobileInChat(
          chatId: chatId,
          immobileListingId: immobileListingId,
        )
        .then((model) => model.toEntity())
        .toAsyncResult();
  }

  @override
  Stream<List<Chat>> watchChats() {
    return datasource.watchChats().map(
          (models) => models.map((m) => m.toEntity()).toList(),
        );
  }

  @override
  Stream<List<ChatMessage>> watchMessages(
    String chatId, {
    required bool isPersonPeerChat,
  }) {
    return datasource.watchMessages(
      chatId,
      isPersonPeerChat: isPersonPeerChat,
    ).map(
          (models) => models.map((m) => m.toEntity()).toList(),
        );
  }

  @override
  Future<void> deleteChat(Chat chat) => datasource.deleteChat(chat);
}
