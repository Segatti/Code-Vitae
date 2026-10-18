import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:result_dart/result_dart.dart';

import '../../domain/entities/chat.dart';
import '../../domain/usecases/list_chats.dart';
import '../../domain/usecases/watch_chats.dart';
import '../../../../shared/presenter/lifecycle/app_lifecycle_bridge.dart';

abstract interface class IChatsListController extends ChangeNotifier {
  String? errorMessage;
  List<String> loadingList = [];
  List<Chat> chats = [];

  Future<Unit> initialize();
  Future<void> refreshChats();
  void resetSessionState();
  @override
  void dispose();
}

class ChatsListController extends IChatsListController {
  final IWatchChats _watchChats;
  final IListChats _listChats;

  ChatsListController(this._watchChats, this._listChats);

  StreamSubscription<List<Chat>>? _subscription;
  bool _resumeListenerRegistered = false;

  @override
  void resetSessionState() {
    if (_resumeListenerRegistered) {
      AppLifecycleBridge.removeResumeListener(_onAppResume);
      _resumeListenerRegistered = false;
    }
    _subscription?.cancel();
    _subscription = null;
    chats = [];
    loadingList.remove('loadChats');
    errorMessage = null;
    notifyListeners();
  }

  @override
  Future<Unit> initialize() async {
    if (!_resumeListenerRegistered) {
      AppLifecycleBridge.addResumeListener(_onAppResume);
      _resumeListenerRegistered = true;
    }

    await _subscription?.cancel();
    _subscription = null;

    chats = [];
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

  void _onAppResume() {
    unawaited(refreshChats());
  }

  @override
  Future<void> refreshChats() async {
    final result = await _listChats();
    result.fold(
      (list) {
        chats = list;
        errorMessage = null;
        notifyListeners();
      },
      (_) {},
    );
  }

  @override
  void dispose() {
    if (_resumeListenerRegistered) {
      AppLifecycleBridge.removeResumeListener(_onAppResume);
      _resumeListenerRegistered = false;
    }
    _subscription?.cancel();
    super.dispose();
  }
}
