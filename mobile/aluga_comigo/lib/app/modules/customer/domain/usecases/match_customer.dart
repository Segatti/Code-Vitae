import 'package:result_dart/result_dart.dart';

import '../../data/repositories/customer_repository.dart';
import '../entities/customer.dart';
import '../enums/match_type.dart';

abstract interface class IMatchCustomer {
  AsyncResult<Unit> call(Customer customer, MatchType matchType);
}

class MatchCustomer implements IMatchCustomer {
  final ICustomerRepository repository;

  const MatchCustomer(this.repository);

  @override
  AsyncResult<Unit> call(Customer customer, MatchType matchType) async {
    if (customer.id.isEmpty || matchType == MatchType.none) {
      return Failure(Exception('Ocorreu um erro ao realizar a ação'));
    }

    return repository.matchCustomer(customer, matchType);
  }
}
