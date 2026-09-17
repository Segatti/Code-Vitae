import '../entities/chat_message.dart';
import '../repositories/chat_repository.dart';

abstract interface class IWatchMessages {
  Stream<List<ChatMessage>> call(
    String chatId, {
    required bool isPersonPeerChat,
  });
}

class WatchMessages implements IWatchMessages {
  final IChatRepository repository;

  const WatchMessages(this.repository);

  @override
  Stream<List<ChatMessage>> call(
    String chatId, {
    required bool isPersonPeerChat,
  }) {
    return repository.watchMessages(
      chatId,
      isPersonPeerChat: isPersonPeerChat,
    );
  }
}
