import 'package:result_dart/result_dart.dart';

import '../../../customer/domain/entities/customer.dart';
import '../../data/repositories/profile_repository.dart';

abstract interface class IUpdateProfile {
  AsyncResult<Unit> call(Customer customer);
}

class UpdateProfile implements IUpdateProfile {
  final IProfileRepository repository;

  const UpdateProfile(this.repository);

  @override
  AsyncResult<Unit> call(Customer customer) async {
    return repository.updateProfile(customer);
  }
}
