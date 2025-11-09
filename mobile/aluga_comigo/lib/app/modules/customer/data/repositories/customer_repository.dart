import 'package:aluga_comigo/app/modules/customer/data/models/customer_model.dart';
import 'package:aluga_comigo/app/shared/domain/extends/result.dart';
import 'package:result_dart/result_dart.dart';

import '../../domain/enums/match_type.dart';
import '../datasources/customer_datasource.dart';

abstract interface class ICustomerRepository {
  AsyncResult<List<CustomerModel>> getCustomers({String? startAfter});
  AsyncResult<Unit> matchCustomer(CustomerModel customer, MatchType matchType);
}

class CustomerRepository implements ICustomerRepository {
  final ICustomerDatasource datasource;

  const CustomerRepository(this.datasource);

  @override
  AsyncResult<List<CustomerModel>> getCustomers({String? startAfter}) async {
    return datasource.getCustomers(startAfter: startAfter).toAsyncResult();
  }

  @override
  AsyncResult<Unit> matchCustomer(CustomerModel customer, MatchType matchType) async {
    return datasource.matchCustomer(customer, matchType).toAsyncResult();
  }
}