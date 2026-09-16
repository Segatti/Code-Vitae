import 'package:result_dart/result_dart.dart';

import '../../../auth/domain/enums/type_user.dart';
import '../../data/models/match_contact_model.dart';
import '../../data/repositories/match_contact_repository.dart';

abstract interface class IListMatchContacts {
  AsyncResult<List<MatchContactModel>> call({
    required TypeUser sessionType,
    required int tabIndex,
  });
}

class ListMatchContacts implements IListMatchContacts {
  final IMatchContactRepository repository;

  const ListMatchContacts(this.repository);

  @override
  AsyncResult<List<MatchContactModel>> call({
    required TypeUser sessionType,
    required int tabIndex,
  }) {
    return repository.listMatchContacts(
      sessionType: sessionType,
      tabIndex: tabIndex,
    );
  }
}
