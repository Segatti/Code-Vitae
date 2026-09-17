import 'package:result_dart/result_dart.dart';

import '../entities/chat_message.dart';
import '../repositories/chat_repository.dart';

abstract interface class ISendMessage {
  AsyncResult<ChatMessage> call(
    String chatId,
    String content, {
    required bool isPersonPeerChat,
  });
}

class SendMessage implements ISendMessage {
  final IChatRepository repository;

  const SendMessage(this.repository);

  @override
  AsyncResult<ChatMessage> call(
    String chatId,
    String content, {
    required bool isPersonPeerChat,
  }) {
    if (content.trim().isEmpty) {
      return Future.value(Failure(Exception('Mensagem vazia')));
    }
    return repository.sendMessage(
      chatId: chatId,
      content: content.trim(),
      isPersonPeerChat: isPersonPeerChat,
    );
  }
}
