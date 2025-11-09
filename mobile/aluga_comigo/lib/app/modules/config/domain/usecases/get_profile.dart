import 'package:aluga_comigo/app/modules/customer/data/models/customer_model.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../shared/data/services/session_service.dart';
import '../../data/repositories/profile_repository.dart';

abstract interface class IGetProfile {
  AsyncResult<CustomerModel> call();
}

class GetProfile implements IGetProfile {
  final IProfileRepository repository;

  const GetProfile(this.repository);

  @override
  AsyncResult<CustomerModel> call() async {
    final id = SessionService.customer!.id;
    return repository.getProfile(id);
  }
}
