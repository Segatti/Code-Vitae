import 'package:aluga_comigo/app/modules/customer/data/datasources/customer_datasource.dart';
import 'package:aluga_comigo/app/modules/customer/data/repositories/customer_repository.dart';
import 'package:aluga_comigo/app/modules/customer/domain/usecases/get_customers.dart';
import 'package:aluga_comigo/app/modules/customer/domain/usecases/match_customer.dart';
import 'package:aluga_comigo/app/modules/customer/domain/usecases/match_immobile_with_super_chat.dart';
import 'package:aluga_comigo/app/modules/customer/presenter/controllers/customers_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CustomerDiModule extends Module {
  @override
  void register(ModularContext c) {
    c.addSingleton<ICustomerRepository>(CustomerRepository.new);
    c.addSingleton<ICustomerDatasource>(CustomerDatasource.new);
    c.addSingleton<IGetCustomers>(GetCustomers.new);
    c.addSingleton<IMatchCustomer>(MatchCustomer.new);
    c.addSingleton<IMatchImmobileWithSuperChat>(MatchImmobileWithSuperChat.new);
    c.addLazySingleton<ICustomersController>(CustomersController.new);
  }
}
