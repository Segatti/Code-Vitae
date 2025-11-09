import 'package:aluga_comigo/app/modules/customer/data/models/customer_model.dart';
import 'package:result_dart/result_dart.dart';

import '../../data/repositories/profile_repository.dart';

abstract interface class IUpdateProfile {
  AsyncResult<Unit> call(CustomerModel customer);
}

class UpdateProfile implements IUpdateProfile {
  final IProfileRepository repository;

  const UpdateProfile(this.repository);

  @override
  AsyncResult<Unit> call(CustomerModel customer) async {
    return repository.updateProfile(customer);
  }
}
