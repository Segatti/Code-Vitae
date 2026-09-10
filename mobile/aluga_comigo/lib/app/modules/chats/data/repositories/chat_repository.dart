import 'package:aluga_comigo/app/shared/domain/extends/result.dart';
import 'package:result_dart/result_dart.dart'
    hide FutureResultExtension, FutureResultExtensionVoid;

import '../../domain/entities/chat.dart';
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
  AsyncResult<List<ChatMessage>> listMessages(String chatId) async {
    return datasource
        .listMessages(chatId)
        .then((models) => models.map((m) => m.toEntity()).toList())
        .toAsyncResult();
  }

  @override
  AsyncResult<ChatMessage> sendMessage({
    required String chatId,
    required String content,
  }) async {
    return datasource
        .sendMessage(chatId: chatId, content: content)
        .then((model) => model.toEntity())
        .toAsyncResult();
  }
}
