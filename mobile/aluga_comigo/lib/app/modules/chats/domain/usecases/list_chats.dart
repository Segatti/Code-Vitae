import 'package:result_dart/result_dart.dart';

import '../entities/chat.dart';
import '../repositories/chat_repository.dart';

abstract interface class IListChats {
  AsyncResult<List<Chat>> call();
}

class ListChats implements IListChats {
  final IChatRepository repository;

  const ListChats(this.repository);

  @override
  AsyncResult<List<Chat>> call() => repository.listChats();
}
