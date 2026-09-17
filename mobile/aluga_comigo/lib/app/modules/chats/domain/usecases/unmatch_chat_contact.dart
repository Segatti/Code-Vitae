import 'package:result_dart/result_dart.dart';

import '../../../customer/data/models/customer_model.dart';
import '../../../customer/domain/enums/match_type.dart';
import '../../../customer/domain/usecases/match_customer.dart';
import '../entities/chat.dart';
import '../repositories/chat_repository.dart';

abstract interface class IUnmatchChatContact {
  AsyncResult<Unit> call({
    required CustomerModel contact,
    required Chat chat,
  });
}

class UnmatchChatContact implements IUnmatchChatContact {
  final IMatchCustomer _matchCustomer;
  final IChatRepository _chatRepository;

  const UnmatchChatContact(this._matchCustomer, this._chatRepository);

  @override
  AsyncResult<Unit> call({
    required CustomerModel contact,
    required Chat chat,
  }) async {
    final matchResult = await _matchCustomer(contact, MatchType.unlike);
    if (matchResult.isError()) {
      final error = matchResult.exceptionOrNull();
      return Failure(error is Exception ? error : Exception('$error'));
    }

    try {
      await _chatRepository.deleteChat(chat);
      return Success(unit);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }
}
