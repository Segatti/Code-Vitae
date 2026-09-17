import 'package:result_dart/result_dart.dart';

import '../../../customer/data/models/customer_model.dart';

abstract interface class IMyImmobilesRepository {
  AsyncResult<List<ImmobileCustomerModel>> listOwnedImmobiles(String accountId);

  AsyncResult<ImmobileCustomerModel> createOwnedListing(String accountId);
}
