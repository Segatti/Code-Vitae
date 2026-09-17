import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:result_dart/result_dart.dart';

import '../../domain/entities/chat.dart';
import '../../domain/usecases/watch_chats.dart';

abstract interface class IChatsListController extends ChangeNotifier {
  String? errorMessage;
  List<String> loadingList = [];
  List<Chat> chats = [];

  Future<Unit> initialize();
  @override
  void dispose();
}

class ChatsListController extends IChatsListController {
  final IWatchChats _watchChats;

  ChatsListController(this._watchChats);

  StreamSubscription<List<Chat>>? _subscription;

  @override
  Future<Unit> initialize() async {
    await _subscription?.cancel();
    _subscription = null;

    loadingList.remove('loadChats');
    loadingList.add('loadChats');
    errorMessage = null;
    notifyListeners();

    _subscription = _watchChats.call().listen(
      (list) {
        chats = list;
        errorMessage = null;
        loadingList.remove('loadChats');
        notifyListeners();
      },
      onError: (_) {
        errorMessage = 'Erro ao carregar conversas';
        loadingList.remove('loadChats');
        notifyListeners();
      },
    );

    return unit;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
