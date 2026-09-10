import 'package:material_ui/material_ui.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

import '../../domain/entities/chat_message.dart';
import '../../domain/usecases/list_messages.dart';
import '../../domain/usecases/send_message.dart';

abstract interface class IChatController extends ChangeNotifier {
  String? errorMessage;
  List<String> loadingList = [];
  List<ChatMessage> messages = [];
  final TextEditingController messageController = TextEditingController();

  Future<Unit> initialize(String chatId);
  Future<bool> loadMessages(String chatId);
  Future<bool> sendMessage(String chatId);
  @override
  void dispose();
}

class ChatController extends IChatController {
  final IListMessages _listMessages;
  final ISendMessage _sendMessage;

  ChatController(this._listMessages, this._sendMessage);

  late final _loadMessagesCommand = Command1(_listMessages.call);
  late final _sendMessageCommand = Command2(_sendMessage.call);

  @override
  Future<Unit> initialize(String chatId) async {
    await loadMessages(chatId);
    return unit;
  }

  @override
  Future<bool> loadMessages(String chatId) async {
    loadingList.add('loadMessages');
    notifyListeners();

    await _loadMessagesCommand.execute(chatId);
    loadingList.remove('loadMessages');

    final result = _loadMessagesCommand.value;
    return result.when(
      data: (list) {
        messages = list;
        errorMessage = null;
        notifyListeners();
        return true;
      },
      failure: (_) {
        errorMessage = 'Erro ao carregar mensagens';
        notifyListeners();
        return false;
      },
      orElse: () => false,
    );
  }

  @override
  Future<bool> sendMessage(String chatId) async {
    final content = messageController.text;
    if (content.trim().isEmpty) return false;

    loadingList.add('sendMessage');
    notifyListeners();

    await _sendMessageCommand.execute(chatId, content);
    loadingList.remove('sendMessage');

    final result = _sendMessageCommand.value;
    return result.when(
      data: (message) {
        messages = [...messages, message];
        messageController.clear();
        errorMessage = null;
        notifyListeners();
        return true;
      },
      failure: (_) {
        errorMessage = 'Erro ao enviar mensagem';
        notifyListeners();
        return false;
      },
      orElse: () => false,
    );
  }

  @override
  void dispose() {
    _loadMessagesCommand.cancel();
    _sendMessageCommand.cancel();
    messageController.dispose();
    super.dispose();
  }
}
