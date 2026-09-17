import 'package:material_ui/material_ui.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../shared/data/services/session_service.dart';
import '../../../auth/domain/enums/type_user.dart';
import '../../../customer/data/models/customer_model.dart';
import '../../data/models/match_contact_model.dart';
import '../../domain/entities/chat.dart';
import '../../domain/usecases/get_or_create_chat_for_contact.dart';
import '../../domain/usecases/list_match_contacts.dart';

abstract interface class IContactListController extends ChangeNotifier {
  List<String> loadingList = [];
  String errorMessage = '';
  List<MatchContactModel> contacts = [];

  Future<Unit> load({required int tabIndex});
  Future<Chat?> resolveChat(CustomerModel customer);
}

class ContactListController extends IContactListController {
  final IListMatchContacts _listMatchContacts;
  final IGetOrCreateChatForContact _getOrCreateChatForContact;

  ContactListController(
    this._listMatchContacts,
    this._getOrCreateChatForContact,
  );

  @override
  Future<Unit> load({required int tabIndex}) async {
    final sessionType = SessionService.customer?.typeUser ?? TypeUser.none;

    loadingList.add('loadContacts');
    errorMessage = '';
    notifyListeners();

    final result = await _listMatchContacts(
      sessionType: sessionType,
      tabIndex: tabIndex,
    );

    loadingList.remove('loadContacts');
    result.fold(
      (list) {
        contacts = list;
        errorMessage = '';
      },
      (_) {
        contacts = [];
        errorMessage = 'Erro ao carregar contatos';
      },
    );
    notifyListeners();
    return unit;
  }

  @override
  Future<Chat?> resolveChat(CustomerModel customer) async {
    loadingList.add('resolveChat');
    notifyListeners();

    final chat = await _getOrCreateChatForContact(customer);

    loadingList.remove('resolveChat');
    notifyListeners();
    return chat;
  }
}
