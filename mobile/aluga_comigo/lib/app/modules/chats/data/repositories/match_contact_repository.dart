import 'package:aluga_comigo/app/shared/domain/extends/result.dart';
import 'package:result_dart/result_dart.dart'
    hide FutureResultExtension, FutureResultExtensionVoid;

import '../../../auth/domain/enums/type_user.dart';
import '../../../customer/data/models/customer_model.dart';
import '../../domain/entities/chat.dart';
import '../datasources/match_contact_datasource.dart';
import '../models/match_contact_model.dart';

abstract interface class IMatchContactRepository {
  AsyncResult<List<MatchContactModel>> listMatchContacts({
    required TypeUser sessionType,
    required int tabIndex,
  });

  Future<Chat?> findChatForContact(CustomerModel customer);
}

class MatchContactRepository implements IMatchContactRepository {
  final IMatchContactDatasource datasource;

  const MatchContactRepository(this.datasource);

  @override
  AsyncResult<List<MatchContactModel>> listMatchContacts({
    required TypeUser sessionType,
    required int tabIndex,
  }) {
    return datasource
        .listMatchContacts(sessionType: sessionType, tabIndex: tabIndex)
        .toAsyncResult();
  }

  @override
  Future<Chat?> findChatForContact(CustomerModel customer) {
    return datasource.findChatForContact(customer);
  }
}
