import 'package:material_ui/material_ui.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../shared/data/services/session_service.dart';
import '../../../auth/domain/enums/type_user.dart';
import '../../../customer/data/models/customer_model.dart';
import '../../data/models/match_contact_model.dart';
import '../../data/repositories/match_contact_repository.dart';
import '../../domain/entities/chat.dart';
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
  final IMatchContactRepository _matchContactRepository;

  ContactListController(this._listMatchContacts, this._matchContactRepository);

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
    return _matchContactRepository.findChatForContact(customer);
  }
}
