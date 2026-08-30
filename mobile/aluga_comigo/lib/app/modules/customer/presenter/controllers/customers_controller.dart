import 'package:aluga_comigo/app/shared/data/services/session_service.dart';
import 'package:material_ui/material_ui.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

import '../../../auth/domain/enums/type_user.dart';
import '../../data/models/customer_model.dart';
import '../../domain/enums/match_type.dart';
import '../../domain/usecases/get_customers.dart';
import '../../domain/usecases/match_customer.dart';

abstract class ICustomersController extends ChangeNotifier {
  List<String> loadingList = [];
  String errorMessage = "";

  List<CustomerModel> customers = [];
  bool hasMore = true;

  Future<Unit> initialize();
  @override
  Future<Unit> dispose();

  Future<bool> getCustomers();
  Future<bool> matchCustomer(CustomerModel customer, MatchType matchType);
}

class CustomersController extends ICustomersController {
  final IGetCustomers _getCustomers;
  final IMatchCustomer _matchCustomer;

  CustomersController(this._getCustomers, this._matchCustomer);

  late final getCustomersCommand = Command0(
    () => _getCustomers.call(
      typeUser: TypeUser.person,
      startAfter: customers.isNotEmpty
          ? customers.last.id
          : (SessionService.customer!.lastMatch.isNotEmpty
              ? SessionService.customer!.lastMatch
              : null),
    ),
  );
  late final matchCustomerCommand = Command2(_matchCustomer.call);

  @override
  Future<bool> getCustomers() async {
    loadingList.add('getCustomers');
    notifyListeners();
    await getCustomersCommand.execute();
    loadingList.remove('getCustomers');
    notifyListeners();
    final result = getCustomersCommand.value;
    return result.when(
      data: (list) {
        if (list.isEmpty) {
          hasMore = false;
        } else {
          customers.addAll(list);
        }
        notifyListeners();
        return true;
      },
      failure: (error) {
        errorMessage = "Erro ao buscar clientes";
        notifyListeners();
        return false;
      },
      orElse: () => false,
    );
  }

  @override
  Future<bool> matchCustomer(CustomerModel customer, MatchType matchType) async {
    loadingList.add('matchCustomer');
    notifyListeners();
    await matchCustomerCommand.execute(customer, matchType);
    loadingList.remove('matchCustomer');
    notifyListeners();
    final result = matchCustomerCommand.value;
    return result.when(
      data: (customer) {
        return true;
      },
      failure: (error) {
        errorMessage = "Erro ao buscar clientes";
        notifyListeners();
        return false;
      },
      orElse: () => false,
    );
  }

  @override
  Future<Unit> initialize() async {
    loadingList.add('initialize');
    notifyListeners();
    await getCustomers();
    loadingList.remove('initialize');
    notifyListeners();
    return unit;
  }

  @override
  Future<Unit> dispose() async {
    loadingList.clear();
    getCustomersCommand.cancel();
    matchCustomerCommand.cancel();
    customers.clear();
    errorMessage = "";
    notifyListeners();
    super.dispose();
    return unit;
  }
}
