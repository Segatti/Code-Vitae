import 'package:aluga_comigo/app/modules/customer/data/models/customer_model.dart';
import 'package:aluga_comigo/app/shared/domain/extends/result.dart';
import 'package:result_dart/result_dart.dart'
    hide FutureResultExtension, FutureResultExtensionVoid;

import '../../../auth/domain/enums/type_user.dart';
import '../../domain/enums/match_type.dart';
import '../datasources/customer_datasource.dart';

abstract interface class ICustomerRepository {
  AsyncResult<List<CustomerModel>> getCustomers({
    required TypeUser typeUser,
    List<String> alreadyLoadedIds = const [],
  });
  AsyncResult<Unit> matchCustomer(CustomerModel customer, MatchType matchType);
}

class CustomerRepository implements ICustomerRepository {
  final ICustomerDatasource datasource;

  const CustomerRepository(this.datasource);

  @override
  AsyncResult<List<CustomerModel>> getCustomers({
    required TypeUser typeUser,
    List<String> alreadyLoadedIds = const [],
  }) async {
    return datasource.getCustomers(
      typeUser: typeUser,
      alreadyLoadedIds: alreadyLoadedIds,
    ).toAsyncResult();
  }

  @override
  AsyncResult<Unit> matchCustomer(
    CustomerModel customer,
    MatchType matchType,
  ) async {
    return datasource.matchCustomer(customer, matchType).toAsyncResult();
  }
}
