import 'package:result_dart/result_dart.dart';

import '../entities/chat_message.dart';
import '../repositories/chat_repository.dart';

abstract interface class ISendSuperChatMessage {
  AsyncResult<ChatMessage> call(
    String chatId,
    String content, {
    required bool isPersonPeerChat,
  });
}

class SendSuperChatMessage implements ISendSuperChatMessage {
  final IChatRepository repository;

  const SendSuperChatMessage(this.repository);

  @override
  AsyncResult<ChatMessage> call(
    String chatId,
    String content, {
    required bool isPersonPeerChat,
  }) {
    if (isPersonPeerChat) {
      return Future.value(
        Failure(Exception('Super Chat não disponível nesta conversa')),
      );
    }
    final trimmed = content.trim();
    if (trimmed.isEmpty) {
      return Future.value(Failure(Exception('Digite uma mensagem')));
    }
    return repository.sendSuperChatMessage(
      chatId: chatId,
      content: trimmed,
    );
  }
}
