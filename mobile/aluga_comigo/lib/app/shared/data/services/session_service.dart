import 'package:aluga_comigo/app/modules/customer/data/models/customer_model.dart';

class UserInventory {
  final int superStarBalance;
  final int superChatBalance;

  const UserInventory({
    this.superStarBalance = 0,
    this.superChatBalance = 0,
  });

  factory UserInventory.fromMap(Map<String, dynamic> map) {
    return UserInventory(
      superStarBalance: (map['superStarBalance'] as num?)?.toInt() ?? 0,
      superChatBalance: (map['superChatBalance'] as num?)?.toInt() ?? 0,
    );
  }
}

class SessionService {
  static CustomerModel? customer;
  static UserInventory inventory = const UserInventory();
  static bool incompleteProfileEntryPromptShown = false;

  static void setCustomer(CustomerModel data) {
    customer = data;
  }

  static void setInventory(UserInventory data) {
    inventory = data;
  }

  static void clearCustomer() {
    customer = null;
    inventory = const UserInventory();
    incompleteProfileEntryPromptShown = false;
  }
}
