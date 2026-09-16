import '../../../customer/data/models/customer_model.dart';
import '../../../customer/domain/enums/match_type.dart';

class MatchContactModel {
  final CustomerModel customer;
  final MatchType matchType;

  const MatchContactModel({required this.customer, required this.matchType});

  factory MatchContactModel.fromMap(Map<String, dynamic> map) {
    return MatchContactModel(
      customer: CustomerModel.fromMap(
        Map<String, dynamic>.from(map['customer'] as Map),
      ),
      matchType: MatchType.get(map['matchType']?.toString() ?? ''),
    );
  }
}
