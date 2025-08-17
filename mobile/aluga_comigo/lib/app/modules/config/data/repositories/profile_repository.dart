import 'package:aluga_comigo/app/shared/domain/extends/result.dart';
import 'package:result_dart/result_dart.dart';

import '../../../customer/domain/entities/customer.dart';
import '../datasources/profile_datasource.dart';

abstract interface class IProfileRepository {
  AsyncResult<Customer> getProfile(String id);
  AsyncResult<Unit> updateProfile(Customer customer);
}

class ProfileRepository implements IProfileRepository {
  final IProfileDatasource datasource;

  ProfileRepository(this.datasource);

  @override
  AsyncResult<Customer> getProfile(String id) {
    return datasource.getProfile(id).toAsyncResult();
  }

  @override
  AsyncResult<Unit> updateProfile(Customer customer) {
    return datasource.updateProfile(customer).toAsyncResult();
  }
}