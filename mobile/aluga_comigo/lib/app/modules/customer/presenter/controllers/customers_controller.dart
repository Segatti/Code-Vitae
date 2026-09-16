import 'package:material_ui/material_ui.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

import '../../../auth/domain/enums/type_user.dart';
import '../../data/models/customer_model.dart';
import '../../domain/constants/swipe_feed_constants.dart';
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
  Future<void> handleSwipe(CustomerModel customer, MatchType matchType);
}

class CustomersController extends ICustomersController {
  final IGetCustomers _getCustomers;
  final IMatchCustomer _matchCustomer;

  CustomersController(this._getCustomers, this._matchCustomer);

  late final getCustomersCommand = Command0(
    () => _getCustomers.call(
      typeUser: TypeUser.person,
      alreadyLoadedIds: customers.map((customer) => customer.id).toList(),
    ),
  );
  late final matchCustomerCommand = Command2(_matchCustomer.call);

  @override
  Future<bool> getCustomers() async {
    if (loadingList.contains('getCustomers')) return false;
    loadingList.add('getCustomers');
    notifyListeners();
    await getCustomersCommand.execute();
    loadingList.remove('getCustomers');
    notifyListeners();
    final result = getCustomersCommand.value;
    return result.when(
      data: (list) {
        if (list.isEmpty || list.length < SwipeFeedConstants.pageSize) {
          hasMore = false;
        }
        if (list.isNotEmpty) {
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
  Future<void> handleSwipe(CustomerModel customer, MatchType matchType) async {
    final success = await matchCustomer(customer, matchType);
    if (success) {
      customers.removeWhere((item) => item.id == customer.id);
      notifyListeners();
    }
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
