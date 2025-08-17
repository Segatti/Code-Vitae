import 'package:aluga_comigo/app/modules/customer/domain/entities/customer.dart';
import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

import '../../domain/usecases/get_profile.dart';
import '../../domain/usecases/update_profile.dart';

abstract interface class IProfileController extends ChangeNotifier {
  String? errorMessage;
  List<String> loadingList = [];

  Customer? customer;

  Future<Unit> initialize();
  @override
  void dispose();

  void updatePage();

  Future<bool> getCustomer();
  Future<bool> updateProfile();
}

class ProfileController extends IProfileController {
  final IGetProfile _getProfile;
  final IUpdateProfile _updateProfile;

  ProfileController(this._getProfile, this._updateProfile);

  late final _getCustomerCommand = Command0<Customer>(_getProfile.call);

  late final _updateProfileCommand = Command1(_updateProfile.call);

  @override
  Future<bool> getCustomer() async {
    loadingList.add('getCustomer');
    notifyListeners();

    await _getCustomerCommand.execute();
    loadingList.remove('getCustomer');
    notifyListeners();

    final result = _getCustomerCommand.value;
    return result.when(
      data: (data) {
        print(data.toJson());
        customer = data;
        notifyListeners();
        return true;
      },
      failure: (error) {
        errorMessage = 'Não foi possivel pegar seu perfil';
        notifyListeners();
        return false;
      },
      orElse: () => false,
    );
  }

  @override
  Future<bool> updateProfile() async {
    if (customer == null) {
      errorMessage = 'Não foi possivel pegar seu perfil';
      notifyListeners();
      return false;
    }

    loadingList.add('updateProfile');
    notifyListeners();

    await _updateProfileCommand.execute(customer!);
    loadingList.remove('updateProfile');
    notifyListeners();

    return true;
  }

  @override
  Future<Unit> initialize() async {
    await getCustomer();

    return unit;
  }

  @override
  void dispose() {
    _getCustomerCommand.cancel();
    _updateProfileCommand.cancel();
    super.dispose();
  }
  
  @override
  void updatePage() {
    notifyListeners();
  }
}
