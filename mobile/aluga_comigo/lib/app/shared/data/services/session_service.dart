import 'package:aluga_comigo/app/modules/customer/data/models/customer_model.dart';

import '../../domain/entities/system_config.dart';

class UserInventory {
  final int superStarBalance;
  final int superChatBalance;
  final bool firstPurchaseOfferEligible;

  const UserInventory({
    this.superStarBalance = 0,
    this.superChatBalance = 0,
    this.firstPurchaseOfferEligible = false,
  });

  factory UserInventory.fromMap(Map<String, dynamic> map) {
    return UserInventory(
      superStarBalance: (map['superStarBalance'] as num?)?.toInt() ?? 0,
      superChatBalance: (map['superChatBalance'] as num?)?.toInt() ?? 0,
      firstPurchaseOfferEligible:
          map['firstPurchaseOfferEligible'] as bool? ?? false,
    );
  }
}

class SessionService {
  static CustomerModel? customer;
  static UserInventory inventory = const UserInventory();
  static SystemConfig systemConfig = SystemConfig.defaults();
  static bool incompleteProfileEntryPromptShown = false;

  static void setCustomer(CustomerModel data) {
    customer = data;
  }

  static void setInventory(UserInventory data) {
    inventory = data;
  }

  static void setSystemConfig(SystemConfig config) {
    systemConfig = config;
  }

  static void clearCustomer() {
    customer = null;
    inventory = const UserInventory();
    incompleteProfileEntryPromptShown = false;
  }
}
