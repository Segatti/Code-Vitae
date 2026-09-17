import 'package:result_dart/result_dart.dart';

import '../../../customer/data/models/customer_model.dart';
import '../repositories/my_immobiles_repository.dart';

abstract interface class ICreateOwnedImmobileListing {
  AsyncResult<ImmobileCustomerModel> call(String accountId);
}

class CreateOwnedImmobileListing implements ICreateOwnedImmobileListing {
  const CreateOwnedImmobileListing(this._repository);

  final IMyImmobilesRepository _repository;

  @override
  AsyncResult<ImmobileCustomerModel> call(String accountId) {
    return _repository.createOwnedListing(accountId);
  }
}
