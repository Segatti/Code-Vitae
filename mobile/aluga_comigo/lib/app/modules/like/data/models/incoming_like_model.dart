import '../../../customer/data/models/customer_model.dart';
import '../../../customer/domain/enums/match_type.dart';

class IncomingLikeModel {
  final CustomerModel customer;
  final MatchType matchType;
  final String? immobileId;
  final ImmobileCustomerModel? sourceImmobile;

  const IncomingLikeModel({
    required this.customer,
    required this.matchType,
    this.immobileId,
    this.sourceImmobile,
  });

  factory IncomingLikeModel.fromMap(Map<String, dynamic> map) {
    final customerMap = Map<String, dynamic>.from(
      map['customer'] as Map<String, dynamic>,
    );
    final immobileRaw = map['immobile'];
    return IncomingLikeModel(
      customer: CustomerModel.fromMap(customerMap),
      matchType: MatchType.get(map['matchType']?.toString() ?? ''),
      immobileId: map['immobileId']?.toString(),
      sourceImmobile: immobileRaw is Map<String, dynamic>
          ? ImmobileCustomerModel.fromMap(immobileRaw)
          : null,
    );
  }
}
