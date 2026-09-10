import '../../../../shared/data/services/session_service.dart';
import '../../../../shared/data/services/supabase_database_service.dart';
import '../models/chat_message_model.dart';
import '../models/chat_model.dart';

abstract interface class IChatDatasource {
  Future<List<ChatModel>> listChats();
  Future<List<ChatMessageModel>> listMessages(String chatId);
  Future<ChatMessageModel> sendMessage({
    required String chatId,
    required String content,
  });
}

class ChatDatasource implements IChatDatasource {
  final SupabaseDatabaseService database;

  const ChatDatasource(this.database);

  @override
  Future<List<ChatModel>> listChats() async {
    final userId = SessionService.customer!.id;
    final rows = await database.listChatsForUser(userId);
    return rows.map<ChatModel>(ChatModel.fromMap).toList();
  }

  @override
  Future<List<ChatMessageModel>> listMessages(String chatId) async {
    final rows = await database.listMessages(chatId);
    return rows.map<ChatMessageModel>(ChatMessageModel.fromMap).toList();
  }

  @override
  Future<ChatMessageModel> sendMessage({
    required String chatId,
    required String content,
  }) async {
    final senderId = SessionService.customer!.id;
    final row = await database.sendMessage(
      chatId: chatId,
      senderId: senderId,
      content: content,
    );
    return ChatMessageModel.fromMap(row);
  }
}
