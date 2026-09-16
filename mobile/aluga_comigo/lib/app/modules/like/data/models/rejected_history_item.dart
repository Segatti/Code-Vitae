import '../../../customer/data/models/customer_model.dart';
import '../../../customer/domain/enums/match_type.dart';

class RejectedHistoryItem {
  final CustomerModel customer;
  final MatchType matchType;
  final DateTime? rejectedAt;

  const RejectedHistoryItem({
    required this.customer,
    this.matchType = MatchType.none,
    this.rejectedAt,
  });

  factory RejectedHistoryItem.fromMap(Map<String, dynamic> map) {
    final customerMap = Map<String, dynamic>.from(
      map['customer'] as Map<String, dynamic>,
    );
    final rejectedAtRaw = map['rejectedAt'];
    return RejectedHistoryItem(
      customer: CustomerModel.fromMap(customerMap),
      matchType: MatchType.get(map['matchType']?.toString() ?? ''),
      rejectedAt: rejectedAtRaw == null
          ? null
          : DateTime.tryParse(rejectedAtRaw.toString()),
    );
  }
}
