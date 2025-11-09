import 'package:aluga_comigo/app/modules/customer/data/models/customer_model.dart';
import 'package:aluga_comigo/app/shared/domain/extends/result.dart';
import 'package:result_dart/result_dart.dart';

import '../datasources/profile_datasource.dart';

abstract interface class IProfileRepository {
  AsyncResult<CustomerModel> getProfile(String id);
  AsyncResult<Unit> updateProfile(CustomerModel customer);
}

class ProfileRepository implements IProfileRepository {
  final IProfileDatasource datasource;

  ProfileRepository(this.datasource);

  @override
  AsyncResult<CustomerModel> getProfile(String id) {
    return datasource.getProfile(id).toAsyncResult();
  }

  @override
  AsyncResult<Unit> updateProfile(CustomerModel customer) {
    return datasource.updateProfile(customer).toAsyncResult();
  }
}