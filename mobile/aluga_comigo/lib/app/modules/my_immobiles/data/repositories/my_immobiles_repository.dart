import 'package:result_dart/result_dart.dart'
    hide FutureResultExtension, FutureResultExtensionVoid;

import '../../../../shared/domain/extends/result.dart';
import '../../../customer/data/models/customer_model.dart';
import '../../domain/repositories/my_immobiles_repository.dart';
import '../datasources/my_immobiles_datasource.dart';

class MyImmobilesRepository implements IMyImmobilesRepository {
  const MyImmobilesRepository(this._datasource);

  final IMyImmobilesDatasource _datasource;

  @override
  AsyncResult<List<ImmobileCustomerModel>> listOwnedImmobiles(
    String accountId,
  ) {
    return _datasource.listOwnedImmobiles(accountId).toAsyncResult();
  }

  @override
  AsyncResult<ImmobileCustomerModel> createOwnedListing(String accountId) {
    return _datasource.createOwnedListing(accountId).toAsyncResult();
  }
}
