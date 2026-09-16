import 'package:aluga_comigo/app/modules/chats/data/datasources/chat_datasource.dart';
import 'package:aluga_comigo/app/modules/chats/data/datasources/match_contact_datasource.dart';
import 'package:aluga_comigo/app/modules/chats/data/repositories/chat_repository.dart';
import 'package:aluga_comigo/app/modules/chats/data/repositories/match_contact_repository.dart';
import 'package:aluga_comigo/app/modules/chats/domain/repositories/chat_repository.dart'
    as domain;
import 'package:aluga_comigo/app/modules/chats/domain/usecases/list_match_contacts.dart';
import 'package:aluga_comigo/app/modules/chats/domain/usecases/list_chats.dart';
import 'package:aluga_comigo/app/modules/chats/domain/usecases/list_messages.dart';
import 'package:aluga_comigo/app/modules/chats/domain/usecases/send_message.dart';
import 'package:aluga_comigo/app/modules/chats/ui/controllers/chat_controller.dart';
import 'package:aluga_comigo/app/modules/chats/ui/controllers/chats_list_controller.dart';
import 'package:aluga_comigo/app/modules/chats/ui/controllers/contact_list_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ChatsDiModule extends Module {
  @override
  void register(ModularContext c) {
    c.addSingleton<IChatDatasource>(ChatDatasource.new);
    c.addSingleton<IMatchContactDatasource>(MatchContactDatasource.new);
    c.addSingleton<domain.IChatRepository>(ChatRepository.new);
    c.addSingleton<IMatchContactRepository>(MatchContactRepository.new);
    c.addSingleton<IListMatchContacts>(ListMatchContacts.new);
    c.addSingleton<IListChats>(ListChats.new);
    c.addSingleton<IListMessages>(ListMessages.new);
    c.addSingleton<ISendMessage>(SendMessage.new);
    c.addLazySingleton<IChatsListController>(ChatsListController.new);
    c.addLazySingleton<IContactListController>(ContactListController.new);
    c.addLazySingleton<IChatController>(ChatController.new);
  }
}
