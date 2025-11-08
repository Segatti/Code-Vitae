import 'package:result_dart/result_dart.dart';

import '../../../../shared/data/services/session_service.dart';
import '../../../customer/domain/entities/customer.dart';
import '../../data/repositories/profile_repository.dart';

abstract interface class IGetProfile {
  AsyncResult<Customer> call();
}

class GetProfile implements IGetProfile {
  final IProfileRepository repository;

  const GetProfile(this.repository);

  @override
  AsyncResult<Customer> call() async {
    final id = SessionService.customer!.id;
    return repository.getProfile(id);
  }
}
