import '../entities/chat.dart';
import '../repositories/chat_repository.dart';

abstract interface class IWatchChats {
  Stream<List<Chat>> call();
}

class WatchChats implements IWatchChats {
  final IChatRepository repository;

  const WatchChats(this.repository);

  @override
  Stream<List<Chat>> call() => repository.watchChats();
}
