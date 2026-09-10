import 'package:aluga_comigo/app/modules/customer/data/models/customer_model.dart';

class SessionService {
  static CustomerModel? customer;
  static bool incompleteProfileEntryPromptShown = false;

  static void setCustomer(CustomerModel data) {
    customer = data;
  }

  static void clearCustomer() {
    customer = null;
    incompleteProfileEntryPromptShown = false;
  }
}
