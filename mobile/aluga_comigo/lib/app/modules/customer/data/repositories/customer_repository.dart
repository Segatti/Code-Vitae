import 'package:aluga_comigo/app/shared/domain/extends/result.dart';
import 'package:result_dart/result_dart.dart';

import '../../domain/entities/customer.dart';
import '../../domain/enums/match_type.dart';
import '../datasources/customer_datasource.dart';

abstract interface class ICustomerRepository {
  AsyncResult<List<Customer>> getCustomers({String? startAfter});
  AsyncResult<Unit> matchCustomer(Customer customer, MatchType matchType);
}

class CustomerRepository implements ICustomerRepository {
  final ICustomerDatasource datasource;

  const CustomerRepository(this.datasource);

  @override
  AsyncResult<List<Customer>> getCustomers({String? startAfter}) async {
    return datasource.getCustomers(startAfter: startAfter).toAsyncResult();
  }

  @override
  AsyncResult<Unit> matchCustomer(Customer customer, MatchType matchType) async {
    return datasource.matchCustomer(customer, matchType).toAsyncResult();
  }
}