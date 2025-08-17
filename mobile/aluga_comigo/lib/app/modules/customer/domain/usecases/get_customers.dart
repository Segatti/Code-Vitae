import 'package:result_dart/result_dart.dart';

import '../../data/repositories/customer_repository.dart';
import '../entities/customer.dart';

abstract interface class IGetCustomers {
  AsyncResult<List<Customer>> call({String? startAfter});
}

class GetCustomers implements IGetCustomers {
  final ICustomerRepository repository;

  const GetCustomers(this.repository);

  @override
  AsyncResult<List<Customer>> call({String? startAfter}) async {
    return repository.getCustomers(startAfter: startAfter);
  }
}
