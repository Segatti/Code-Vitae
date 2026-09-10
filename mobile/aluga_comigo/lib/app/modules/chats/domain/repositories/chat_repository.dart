import 'package:result_dart/result_dart.dart';

import '../entities/chat.dart';
import '../entities/chat_message.dart';

abstract interface class IChatRepository {
  AsyncResult<List<Chat>> listChats();
  AsyncResult<List<ChatMessage>> listMessages(String chatId);
  AsyncResult<ChatMessage> sendMessage({
    required String chatId,
    required String content,
  });
}
