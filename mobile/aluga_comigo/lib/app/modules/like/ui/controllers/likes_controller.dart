import 'package:material_ui/material_ui.dart';
import 'package:result_dart/result_dart.dart';

import '../../../customer/data/models/customer_model.dart';
import '../../../customer/domain/entities/swipe_action_result.dart';
import '../../../customer/domain/enums/match_type.dart';
import '../../../customer/domain/usecases/match_customer.dart';
import '../../data/models/incoming_like_model.dart';
import '../../domain/usecases/get_incoming_likes.dart';

abstract interface class ILikesController extends ChangeNotifier {
  List<String> loadingList = [];
  String errorMessage = '';
  List<IncomingLikeModel> items = [];

  List<IncomingLikeModel> get superStars;
  List<IncomingLikeModel> get likes;
  List<PersonCustomerModel> get persons;
  List<ImmobileCustomerModel> get immobiles;

  Future<Unit> initialize();
  Future<SwipeActionResult> respondToLike(
    IncomingLikeModel item,
    MatchType matchType,
  );
}

class LikesController extends ILikesController {
  final IGetIncomingLikes _getIncomingLikes;
  final IMatchCustomer _matchCustomer;

  LikesController(this._getIncomingLikes, this._matchCustomer);

  @override
  List<IncomingLikeModel> get superStars =>
      items.where((item) => item.matchType == MatchType.favorite).toList();

  @override
  List<IncomingLikeModel> get likes =>
      items.where((item) => item.matchType == MatchType.like).toList();

  @override
  List<PersonCustomerModel> get persons => items
      .map((item) => item.customer)
      .whereType<PersonCustomerModel>()
      .toList();

  @override
  List<ImmobileCustomerModel> get immobiles => items
      .map((item) => item.customer)
      .whereType<ImmobileCustomerModel>()
      .toList();

  @override
  Future<Unit> initialize() async {
    if (loadingList.contains('loadLikes')) return unit;

    loadingList.add('loadLikes');
    notifyListeners();

    final result = await _getIncomingLikes();

    loadingList.remove('loadLikes');
    result.fold(
      (data) {
        items = data;
        errorMessage = '';
      },
      (_) {
        errorMessage = 'Erro ao carregar curtidas';
        items = [];
      },
    );
    notifyListeners();
    return unit;
  }

  @override
  Future<SwipeActionResult> respondToLike(
    IncomingLikeModel item,
    MatchType matchType,
  ) async {
    loadingList.add('respondLike');
    notifyListeners();

    final result = await _matchCustomer(item.customer, matchType);

    loadingList.remove('respondLike');
    return result.fold(
      (response) {
        items.removeWhere(
          (entry) => entry.customer.id == item.customer.id,
        );
        errorMessage = '';
        notifyListeners();
        return SwipeActionResult(
          removed: true,
          mutualMatch: response.mutualMatch,
        );
      },
      (_) {
        errorMessage = 'Erro ao responder curtida';
        notifyListeners();
        return const SwipeActionResult(removed: false);
      },
    );
  }
}
