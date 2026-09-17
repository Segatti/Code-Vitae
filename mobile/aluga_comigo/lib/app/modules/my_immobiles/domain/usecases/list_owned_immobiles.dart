import 'package:result_dart/result_dart.dart';

import '../../../customer/data/models/customer_model.dart';
import '../repositories/my_immobiles_repository.dart';

abstract interface class IListOwnedImmobiles {
  AsyncResult<List<ImmobileCustomerModel>> call(String accountId);
}

class ListOwnedImmobiles implements IListOwnedImmobiles {
  const ListOwnedImmobiles(this._repository);

  final IMyImmobilesRepository _repository;

  @override
  AsyncResult<List<ImmobileCustomerModel>> call(String accountId) {
    return _repository.listOwnedImmobiles(accountId);
  }
}
