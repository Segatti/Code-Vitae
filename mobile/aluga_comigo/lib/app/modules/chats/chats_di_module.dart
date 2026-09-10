import 'package:aluga_comigo/app/modules/chats/data/datasources/chat_datasource.dart';
import 'package:aluga_comigo/app/modules/chats/data/repositories/chat_repository.dart';
import 'package:aluga_comigo/app/modules/chats/domain/repositories/chat_repository.dart'
    as domain;
import 'package:aluga_comigo/app/modules/chats/domain/usecases/list_chats.dart';
import 'package:aluga_comigo/app/modules/chats/domain/usecases/list_messages.dart';
import 'package:aluga_comigo/app/modules/chats/domain/usecases/send_message.dart';
import 'package:aluga_comigo/app/modules/chats/ui/controllers/chat_controller.dart';
import 'package:aluga_comigo/app/modules/chats/ui/controllers/chats_list_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ChatsDiModule extends Module {
  @override
  void register(ModularContext c) {
    c.addSingleton<IChatDatasource>(ChatDatasource.new);
    c.addSingleton<domain.IChatRepository>(ChatRepository.new);
    c.addSingleton<IListChats>(ListChats.new);
    c.addSingleton<IListMessages>(ListMessages.new);
    c.addSingleton<ISendMessage>(SendMessage.new);
    c.addSingleton<IChatsListController>(ChatsListController.new);
    c.add<IChatController>(ChatController.new);
  }
}
