import 'package:result_dart/result_dart.dart';

import '../../../customer/data/models/customer_model.dart';
import '../entities/chat.dart';
import '../entities/chat_immobile_offer.dart';
import '../entities/chat_message.dart';

abstract interface class IChatRepository {
  AsyncResult<List<Chat>> listChats();
  AsyncResult<List<ChatMessage>> listMessages(
    String chatId, {
    required bool isPersonPeerChat,
  });
  AsyncResult<ChatMessage> sendMessage({
    required String chatId,
    required String content,
    required bool isPersonPeerChat,
  });
  AsyncResult<ChatMessage> sendSuperChatMessage({
    required String chatId,
    required String content,
  });

  AsyncResult<ImmobileCustomerModel> getImmobileListing(String listingId);
  AsyncResult<List<ChatImmobileOffer>> listImmobileOffers(String chatId);
  AsyncResult<ChatImmobileOffer> offerImmobileInChat({
    required String chatId,
    required String immobileListingId,
  });

  Stream<List<Chat>> watchChats();

  Stream<List<ChatMessage>> watchMessages(
    String chatId, {
    required bool isPersonPeerChat,
  });

  Future<void> deleteChat(Chat chat);
}
