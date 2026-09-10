import 'package:result_dart/result_dart.dart';

import '../entities/chat_message.dart';
import '../repositories/chat_repository.dart';

abstract interface class IListMessages {
  AsyncResult<List<ChatMessage>> call(String chatId);
}

class ListMessages implements IListMessages {
  final IChatRepository repository;

  const ListMessages(this.repository);

  @override
  AsyncResult<List<ChatMessage>> call(String chatId) {
    return repository.listMessages(chatId);
  }
}
