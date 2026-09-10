import '../../../customer/data/models/customer_model.dart';
import '../../../customer/domain/enums/match_type.dart';

class IncomingLikeModel {
  final CustomerModel customer;
  final MatchType matchType;

  const IncomingLikeModel({
    required this.customer,
    required this.matchType,
  });

  factory IncomingLikeModel.fromMap(Map<String, dynamic> map) {
    final customerMap = Map<String, dynamic>.from(
      map['customer'] as Map<String, dynamic>,
    );
    return IncomingLikeModel(
      customer: CustomerModel.fromMap(customerMap),
      matchType: MatchType.get(map['matchType']?.toString() ?? ''),
    );
  }
}
