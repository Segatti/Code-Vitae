import 'package:result_dart/result_dart.dart';

import '../entities/chat_immobile_offer.dart';
import '../repositories/chat_repository.dart';

abstract interface class IListChatImmobileOffers {
  AsyncResult<List<ChatImmobileOffer>> call(String chatId);
}

class ListChatImmobileOffers implements IListChatImmobileOffers {
  final IChatRepository repository;

  const ListChatImmobileOffers(this.repository);

  @override
  AsyncResult<List<ChatImmobileOffer>> call(String chatId) {
    return repository.listImmobileOffers(chatId);
  }
}
