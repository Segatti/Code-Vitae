import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:result_dart/result_dart.dart';

import '../../domain/entities/chat.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/usecases/list_messages.dart';
import '../../domain/usecases/send_message.dart';
import '../../domain/usecases/watch_messages.dart';

abstract interface class IChatController extends ChangeNotifier {
  String? errorMessage;
  List<String> loadingList = [];
  List<ChatMessage> messages = [];
  final TextEditingController messageController = TextEditingController();

  Future<Unit> initialize(Chat chat);
  Future<bool> loadMessages();
  Future<bool> sendMessage();
  @override
  void dispose();
}

class ChatController extends IChatController {
  final IListMessages _listMessages;
  final ISendMessage _sendMessage;
  final IWatchMessages _watchMessages;

  ChatController(
    this._listMessages,
    this._sendMessage,
    this._watchMessages,
  );

  Chat? _chat;
  StreamSubscription<List<ChatMessage>>? _messagesSubscription;

  @override
  Future<Unit> initialize(Chat chat) async {
    await _messagesSubscription?.cancel();
    _messagesSubscription = null;
    _chat = chat;
    messages = [];
    errorMessage = null;
    loadingList = [];
    await loadMessages();

    _messagesSubscription = _watchMessages(
      chat.id,
      isPersonPeerChat: chat.isPersonPeerChat,
    ).listen(
      (list) {
        messages = list;
        errorMessage = null;
        notifyListeners();
      },
      onError: (_) {
        errorMessage = 'Erro ao atualizar mensagens';
        notifyListeners();
      },
    );

    return unit;
  }

  @override
  Future<bool> loadMessages() async {
    final chat = _chat;
    if (chat == null) return false;

    loadingList.add('loadMessages');
    notifyListeners();

    final result = await _listMessages(
      chat.id,
      isPersonPeerChat: chat.isPersonPeerChat,
    );

    loadingList.remove('loadMessages');

    return result.fold(
      (list) {
        messages = list;
        errorMessage = null;
        notifyListeners();
        return true;
      },
      (_) {
        errorMessage = 'Erro ao carregar mensagens';
        notifyListeners();
        return false;
      },
    );
  }

  @override
  Future<bool> sendMessage() async {
    final chat = _chat;
    if (chat == null) return false;

    final content = messageController.text;
    if (content.trim().isEmpty) return false;

    loadingList.add('sendMessage');
    notifyListeners();

    final result = await _sendMessage(
      chat.id,
      content,
      isPersonPeerChat: chat.isPersonPeerChat,
    );

    loadingList.remove('sendMessage');

    return result.fold(
      (message) {
        messages = [...messages, message];
        messageController.clear();
        errorMessage = null;
        notifyListeners();
        return true;
      },
      (_) {
        errorMessage = 'Erro ao enviar mensagem';
        notifyListeners();
        return false;
      },
    );
  }

  @override
  void dispose() {
    unawaited(_messagesSubscription?.cancel());
    _messagesSubscription = null;
    messageController.dispose();
    super.dispose();
  }
}
