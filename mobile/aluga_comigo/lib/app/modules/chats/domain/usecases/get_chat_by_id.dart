import 'package:result_dart/result_dart.dart';

import '../entities/chat.dart';
import '../repositories/chat_repository.dart';

abstract interface class IGetChatById {
  AsyncResult<Chat> call(String chatId);
}

class GetChatById implements IGetChatById {
  final IChatRepository repository;

  const GetChatById(this.repository);

  @override
  AsyncResult<Chat> call(String chatId) => repository.getChatById(chatId);
}
