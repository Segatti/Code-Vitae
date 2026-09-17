import 'package:material_ui/material_ui.dart';
import 'package:result_dart/result_dart.dart';

import '../../../customer/data/models/customer_model.dart';
import '../../domain/usecases/create_owned_immobile_listing.dart';
import '../../domain/usecases/list_owned_immobiles.dart';

abstract interface class IMyImmobilesController extends ChangeNotifier {
  List<String> loadingList = [];
  String errorMessage = '';
  List<ImmobileCustomerModel> immobiles = [];

  Future<Unit> initialize(String accountId);

  Future<ImmobileCustomerModel?> createListing(String accountId);
}

class MyImmobilesController extends IMyImmobilesController {
  MyImmobilesController(
    this._listOwnedImmobiles,
    this._createOwnedImmobileListing,
  );

  final IListOwnedImmobiles _listOwnedImmobiles;
  final ICreateOwnedImmobileListing _createOwnedImmobileListing;

  @override
  Future<Unit> initialize(String accountId) async {
    if (loadingList.contains('loadImmobiles')) return unit;

    loadingList.add('loadImmobiles');
    errorMessage = '';
    notifyListeners();

    final result = await _listOwnedImmobiles(accountId);

    loadingList.remove('loadImmobiles');
    result.fold(
      (data) {
        immobiles = data;
        errorMessage = '';
      },
      (_) {
        immobiles = [];
        errorMessage = 'Erro ao carregar seus imóveis';
      },
    );
    notifyListeners();
    return unit;
  }

  @override
  Future<ImmobileCustomerModel?> createListing(String accountId) async {
    if (loadingList.contains('createListing')) return null;

    loadingList.add('createListing');
    errorMessage = '';
    notifyListeners();

    final result = await _createOwnedImmobileListing(accountId);

    loadingList.remove('createListing');

    return result.fold(
      (immobile) {
        errorMessage = '';
        notifyListeners();
        return immobile;
      },
      (_) {
        errorMessage = 'Não foi possível criar o imóvel';
        notifyListeners();
        return null;
      },
    );
  }
}
