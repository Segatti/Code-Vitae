import 'package:aluga_comigo/app/modules/customer/data/models/customer_model.dart';
import 'package:aluga_comigo/app/shared/domain/extends/result.dart';
import 'package:result_dart/result_dart.dart'
    hide FutureResultExtension, FutureResultExtensionVoid;

import '../../../auth/domain/enums/type_user.dart';
import '../../domain/entities/match_customer_response.dart';
import '../../domain/enums/match_type.dart';
import '../datasources/customer_datasource.dart';

abstract interface class ICustomerRepository {
  AsyncResult<List<CustomerModel>> getCustomers({
    required TypeUser typeUser,
    List<String> alreadyLoadedIds = const [],
  });
  AsyncResult<MatchCustomerResponse> matchCustomer(
    CustomerModel customer,
    MatchType matchType,
  );
  AsyncResult<MatchCustomerResponse> matchImmobileWithSuperChat({
    required ImmobileCustomerModel immobile,
    required String message,
  });
}

class CustomerRepository implements ICustomerRepository {
  final ICustomerDatasource datasource;

  const CustomerRepository(this.datasource);

  @override
  AsyncResult<List<CustomerModel>> getCustomers({
    required TypeUser typeUser,
    List<String> alreadyLoadedIds = const [],
  }) async {
    return datasource.getCustomers(
      typeUser: typeUser,
      alreadyLoadedIds: alreadyLoadedIds,
    ).toAsyncResult();
  }

  @override
  AsyncResult<MatchCustomerResponse> matchCustomer(
    CustomerModel customer,
    MatchType matchType,
  ) async {
    return datasource.matchCustomer(customer, matchType).toAsyncResult();
  }

  @override
  AsyncResult<MatchCustomerResponse> matchImmobileWithSuperChat({
    required ImmobileCustomerModel immobile,
    required String message,
  }) async {
    return datasource
        .matchImmobileWithSuperChat(immobile: immobile, message: message)
        .toAsyncResult();
  }
}
