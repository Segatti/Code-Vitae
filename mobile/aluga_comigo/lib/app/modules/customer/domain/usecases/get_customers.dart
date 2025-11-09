import 'package:aluga_comigo/app/modules/customer/data/models/customer_model.dart';
import 'package:result_dart/result_dart.dart';

import '../../data/repositories/customer_repository.dart';

abstract interface class IGetCustomers {
  AsyncResult<List<CustomerModel>> call({String? startAfter});
}

class GetCustomers implements IGetCustomers {
  final ICustomerRepository repository;

  const GetCustomers(this.repository);

  @override
  AsyncResult<List<CustomerModel>> call({String? startAfter}) async {
    return repository.getCustomers(startAfter: startAfter);
  }
}
