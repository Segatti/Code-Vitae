import 'package:aluga_comigo/app/modules/customer/presenter/pages/customers_page.dart';
import 'package:aluga_comigo/app/shared/core_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../shared/data/services/firebase_database_service.dart';
import 'data/datasources/customer_datasource.dart';
import 'data/repositories/customer_repository.dart';
import 'domain/usecases/get_customers.dart';
import 'domain/usecases/match_customer.dart';
import 'presenter/controllers/customers_controller.dart';

class CustomerModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];

  @override
  void exportedBinds(Injector i) {
    // Repository
    i.addSingleton<ICustomerRepository>(CustomerRepository.new);

    // Datasource
    i.addSingleton<ICustomerDatasource>(CustomerDatasource.new);

    // Usecase
    i.addSingleton<IGetCustomers>(GetCustomers.new);
    i.addSingleton<IMatchCustomer>(MatchCustomer.new);
  }

  @override
  void binds(Injector i) {
    // Repository
    i.addSingleton<ICustomerRepository>(CustomerRepository.new);

    // Datasource
    i.addSingleton<ICustomerDatasource>(CustomerDatasource.new);

    // Usecase
    i.addSingleton<IGetCustomers>(GetCustomers.new);
    i.addSingleton<IMatchCustomer>(MatchCustomer.new);

    // Services
    i.addSingleton<FirebaseDatabaseService>(FirebaseDatabaseService.new);

    // Controller
    i.add<ICustomersController>(CustomersController.new);
  }

  @override
  void routes(RouteManager r) {
    r.child(
      "/",
      child: (context) => const CustomersPage(),
      transition: TransitionType.upToDown,
    );
  }
}
