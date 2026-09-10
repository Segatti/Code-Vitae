import 'package:material_ui/material_ui.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

import '../../domain/entities/chat.dart';
import '../../domain/usecases/list_chats.dart';

abstract interface class IChatsListController extends ChangeNotifier {
  String? errorMessage;
  List<String> loadingList = [];
  List<Chat> chats = [];

  Future<Unit> initialize();
  Future<bool> loadChats();
  @override
  void dispose();
}

class ChatsListController extends IChatsListController {
  final IListChats _listChats;

  ChatsListController(this._listChats);

  late final _loadChatsCommand = Command0(_listChats.call);

  @override
  Future<Unit> initialize() async {
    await loadChats();
    return unit;
  }

  @override
  Future<bool> loadChats() async {
    loadingList.add('loadChats');
    notifyListeners();

    await _loadChatsCommand.execute();
    loadingList.remove('loadChats');

    final result = _loadChatsCommand.value;
    return result.when(
      data: (list) {
        chats = list;
        errorMessage = null;
        notifyListeners();
        return true;
      },
      failure: (_) {
        errorMessage = 'Erro ao carregar conversas';
        notifyListeners();
        return false;
      },
      orElse: () => false,
    );
  }

  @override
  void dispose() {
    _loadChatsCommand.cancel();
    super.dispose();
  }
}
