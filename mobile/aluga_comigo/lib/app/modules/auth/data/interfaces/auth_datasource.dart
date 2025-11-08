import '../../../customer/data/models/customer_model.dart';
import '../../domain/entities/inputs/login_input.dart';
import '../../domain/entities/inputs/signup_input.dart';

abstract class IAuthDatasource {
  Future<CustomerModel> login(LoginInput input);
  Future<CustomerModel> signupUser(SignupUserInput input);
  Future<CustomerModel> signupImmobile(SignupImmobileInput input);
  Future<bool> recoverPassword(String input);
}
