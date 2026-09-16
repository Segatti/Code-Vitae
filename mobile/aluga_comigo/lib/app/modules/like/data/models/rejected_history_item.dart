import '../../../customer/data/models/customer_model.dart';

class RejectedHistoryItem {
  final CustomerModel customer;
  final DateTime? rejectedAt;

  const RejectedHistoryItem({
    required this.customer,
    this.rejectedAt,
  });

  factory RejectedHistoryItem.fromMap(Map<String, dynamic> map) {
    final customerMap = Map<String, dynamic>.from(
      map['customer'] as Map<String, dynamic>,
    );
    final rejectedAtRaw = map['rejectedAt'];
    return RejectedHistoryItem(
      customer: CustomerModel.fromMap(customerMap),
      rejectedAt: rejectedAtRaw == null
          ? null
          : DateTime.tryParse(rejectedAtRaw.toString()),
    );
  }
}
