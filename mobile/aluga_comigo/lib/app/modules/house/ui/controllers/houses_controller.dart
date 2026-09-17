import 'package:material_ui/material_ui.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

import '../../../auth/domain/enums/type_user.dart';
import '../../../customer/data/models/customer_model.dart';
import '../../../customer/domain/constants/swipe_feed_constants.dart';
import '../../../customer/domain/entities/match_customer_response.dart';
import '../../../customer/domain/entities/swipe_action_result.dart';
import '../../../customer/domain/enums/match_type.dart';
import '../../../customer/domain/usecases/get_customers.dart';
import '../../../customer/domain/usecases/match_customer.dart';
import '../../../customer/domain/usecases/match_immobile_with_super_chat.dart';

abstract class IHousesController extends ChangeNotifier {
  List<String> loadingList = [];
  String errorMessage = "";

  List<CustomerModel> houses = [];
  bool hasMore = true;

  Future<Unit> initialize();
  void resetFeedState();
  @override
  Future<Unit> dispose();

  Future<bool> getHouses();
  Future<MatchCustomerResponse?> matchHouse(
    CustomerModel customer,
    MatchType matchType,
  );
  Future<SwipeActionResult> superChatFavoriteImmobile(
    ImmobileCustomerModel immobile,
    String message,
  );
  Future<SwipeActionResult> handleSwipe(
    CustomerModel customer,
    MatchType matchType,
  );
}

class HousesController extends IHousesController {
  final IGetCustomers _getCustomers;
  final IMatchCustomer _matchCustomer;
  final IMatchImmobileWithSuperChat _matchImmobileWithSuperChat;

  HousesController(
    this._getCustomers,
    this._matchCustomer,
    this._matchImmobileWithSuperChat,
  );

  late final getHousesCommand = Command0(
    () => _getCustomers.call(
      typeUser: TypeUser.immobile,
      alreadyLoadedIds: houses.map((house) => house.id).toList(),
    ),
  );
  late final matchHouseCommand = Command2(_matchCustomer.call);

  @override
  Future<bool> getHouses() async {
    if (loadingList.contains('getHouses')) return false;
    loadingList.add('getHouses');
    notifyListeners();
    await getHousesCommand.execute();
    loadingList.remove('getHouses');
    notifyListeners();
    final result = getHousesCommand.value;
    return result.when(
      data: (list) {
        if (list.isEmpty || list.length < SwipeFeedConstants.pageSize) {
          hasMore = false;
        }
        if (list.isNotEmpty) {
          houses.addAll(list);
        }
        notifyListeners();
        return true;
      },
      failure: (error) {
        errorMessage = "Erro ao buscar imóveis";
        hasMore = false;
        notifyListeners();
        return false;
      },
      orElse: () {
        hasMore = false;
        notifyListeners();
        return false;
      },
    );
  }

  @override
  Future<SwipeActionResult> superChatFavoriteImmobile(
    ImmobileCustomerModel immobile,
    String message,
  ) async {
    loadingList.add('superChatFavorite');
    notifyListeners();

    final result = await _matchImmobileWithSuperChat(
      immobile: immobile,
      message: message,
    );

    loadingList.remove('superChatFavorite');
    return result.fold(
      (response) {
        houses.removeWhere((item) => item.id == immobile.id);
        errorMessage = '';
        notifyListeners();
        return SwipeActionResult(
          removed: true,
          mutualMatch: response.mutualMatch,
        );
      },
      (_) {
        errorMessage = 'Erro ao favoritar com Super Chat';
        notifyListeners();
        return const SwipeActionResult(removed: false);
      },
    );
  }

  @override
  Future<SwipeActionResult> handleSwipe(
    CustomerModel customer,
    MatchType matchType,
  ) async {
    final outcome = await matchHouse(customer, matchType);
    if (outcome == null) {
      return const SwipeActionResult(removed: false);
    }
    houses.removeWhere((item) => item.id == customer.id);
    notifyListeners();
    return SwipeActionResult(
      removed: true,
      mutualMatch: outcome.mutualMatch,
    );
  }

  @override
  Future<MatchCustomerResponse?> matchHouse(
    CustomerModel customer,
    MatchType matchType,
  ) async {
    loadingList.add('matchHouse');
    notifyListeners();
    await matchHouseCommand.execute(customer, matchType);
    loadingList.remove('matchHouse');
    notifyListeners();
    final result = matchHouseCommand.value;
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
    houses.clear();
    hasMore = true;
    errorMessage = '';
    notifyListeners();
  }

  @override
  Future<Unit> initialize() async {
    resetFeedState();
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
