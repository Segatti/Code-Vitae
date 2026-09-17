import 'package:material_ui/material_ui.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

import '../../../auth/domain/enums/type_user.dart';
import '../../data/models/customer_model.dart';
import '../../domain/constants/swipe_feed_constants.dart';
import '../../domain/entities/match_customer_response.dart';
import '../../domain/entities/swipe_action_result.dart';
import '../../domain/enums/match_type.dart';
import '../../domain/usecases/get_customers.dart';
import '../../domain/usecases/match_customer.dart';

abstract class ICustomersController extends ChangeNotifier {
  List<String> loadingList = [];
  String errorMessage = "";

  List<CustomerModel> customers = [];
  bool hasMore = true;

  Future<Unit> initialize();
  void resetFeedState();
  @override
  Future<Unit> dispose();

  Future<bool> getCustomers();
  Future<MatchCustomerResponse?> matchCustomer(
    CustomerModel customer,
    MatchType matchType,
  );
  Future<SwipeActionResult> handleSwipe(
    CustomerModel customer,
    MatchType matchType,
  );
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
  Future<SwipeActionResult> handleSwipe(
    CustomerModel customer,
    MatchType matchType,
  ) async {
    final outcome = await matchCustomer(customer, matchType);
    if (outcome == null) {
      return const SwipeActionResult(removed: false);
    }
    customers.removeWhere((item) => item.id == customer.id);
    notifyListeners();
    return SwipeActionResult(
      removed: true,
      mutualMatch: outcome.mutualMatch,
    );
  }

  @override
  Future<MatchCustomerResponse?> matchCustomer(
    CustomerModel customer,
    MatchType matchType,
  ) async {
    loadingList.add('matchCustomer');
    notifyListeners();
    await matchCustomerCommand.execute(customer, matchType);
    loadingList.remove('matchCustomer');
    notifyListeners();
    final result = matchCustomerCommand.value;
    return result.when(
      data: (response) {
        errorMessage = '';
        return response;
      },
      failure: (error) {
        errorMessage = "Erro ao buscar clientes";
        notifyListeners();
        return null;
      },
      orElse: () => null,
    );
  }

  @override
  void resetFeedState() {
    customers.clear();
    hasMore = true;
    errorMessage = '';
    notifyListeners();
  }

  @override
  Future<Unit> initialize() async {
    resetFeedState();
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
