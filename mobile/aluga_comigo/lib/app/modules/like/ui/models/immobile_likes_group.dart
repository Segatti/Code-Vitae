import '../../../customer/data/models/customer_model.dart';
import '../../data/models/incoming_like_model.dart';

class ImmobileLikesGroup {
  final ImmobileCustomerModel immobile;
  final List<IncomingLikeModel> items;

  const ImmobileLikesGroup({
    required this.immobile,
    required this.items,
  });
}
