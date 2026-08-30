import 'package:aluga_comigo/app/shared/data/services/session_service.dart';
import 'package:material_ui/material_ui.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

import '../../../auth/domain/enums/type_user.dart';
import '../../../customer/data/models/customer_model.dart';
import '../../../customer/domain/enums/match_type.dart';
import '../../../customer/domain/usecases/get_customers.dart';
import '../../../customer/domain/usecases/match_customer.dart';

abstract class IHousesController extends ChangeNotifier {
  List<String> loadingList = [];
  String errorMessage = "";

  List<CustomerModel> houses = [];
  bool hasMore = true;

  Future<Unit> initialize();
  @override
  Future<Unit> dispose();

  Future<bool> getHouses();
  Future<bool> matchHouse(CustomerModel customer, MatchType matchType);
}

class HousesController extends IHousesController {
  final IGetCustomers _getCustomers;
  final IMatchCustomer _matchCustomer;

  HousesController(this._getCustomers, this._matchCustomer);

  late final getHousesCommand = Command0(
    () => _getCustomers.call(
      typeUser: TypeUser.immobile,
      startAfter: houses.isNotEmpty
          ? houses.last.id
          : (SessionService.customer!.lastMatch.isNotEmpty
              ? SessionService.customer!.lastMatch
              : null),
    ),
  );
  late final matchHouseCommand = Command2(_matchCustomer.call);

  @override
  Future<bool> getHouses() async {
    loadingList.add('getHouses');
    notifyListeners();
    await getHousesCommand.execute();
    loadingList.remove('getHouses');
    notifyListeners();
    final result = getHousesCommand.value;
    return result.when(
      data: (list) {
        if (list.isEmpty) {
          hasMore = false;
        } else {
          houses.addAll(list);
        }
        notifyListeners();
        return true;
      },
      failure: (error) {
        errorMessage = "Erro ao buscar imóveis";
        notifyListeners();
        return false;
      },
      orElse: () => false,
    );
  }

  @override
  Future<bool> matchHouse(CustomerModel customer, MatchType matchType) async {
    loadingList.add('matchHouse');
    notifyListeners();
    await matchHouseCommand.execute(customer, matchType);
    loadingList.remove('matchHouse');
    notifyListeners();
    final result = matchHouseCommand.value;
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
    await getHouses();
    loadingList.remove('initialize');
    notifyListeners();
    return unit;
  }

  @override
  Future<Unit> dispose() async {
    loadingList.clear();
    getHousesCommand.cancel();
    matchHouseCommand.cancel();
    houses.clear();
    errorMessage = "";
    notifyListeners();
    super.dispose();
    return unit;
  }
}
