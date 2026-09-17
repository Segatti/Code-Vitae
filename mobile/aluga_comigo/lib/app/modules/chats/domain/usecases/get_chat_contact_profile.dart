import 'package:result_dart/result_dart.dart';

import '../../../customer/data/models/customer_model.dart';
import '../../data/repositories/match_contact_repository.dart';

abstract interface class IGetChatContactProfile {
  AsyncResult<CustomerModel> call(String accountId);
}

class GetChatContactProfile implements IGetChatContactProfile {
  final IMatchContactRepository repository;

  const GetChatContactProfile(this.repository);

  @override
  AsyncResult<CustomerModel> call(String accountId) {
    if (accountId.isEmpty) {
      return Future.value(Failure(Exception('Contato inválido')));
    }
    return repository.getContactProfile(accountId);
  }
}
