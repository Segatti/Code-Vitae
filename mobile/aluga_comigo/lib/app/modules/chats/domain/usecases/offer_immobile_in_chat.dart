import 'package:result_dart/result_dart.dart';

import '../entities/chat_immobile_offer.dart';
import '../repositories/chat_repository.dart';

abstract interface class IOfferImmobileInChat {
  AsyncResult<ChatImmobileOffer> call({
    required String chatId,
    required String immobileListingId,
  });
}

class OfferImmobileInChat implements IOfferImmobileInChat {
  final IChatRepository repository;

  const OfferImmobileInChat(this.repository);

  @override
  AsyncResult<ChatImmobileOffer> call({
    required String chatId,
    required String immobileListingId,
  }) {
    return repository.offerImmobileInChat(
      chatId: chatId,
      immobileListingId: immobileListingId,
    );
  }
}
