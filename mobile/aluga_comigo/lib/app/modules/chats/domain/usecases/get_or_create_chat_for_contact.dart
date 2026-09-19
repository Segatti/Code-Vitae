import '../../../customer/data/models/customer_model.dart';
import '../entities/chat.dart';
import '../../data/repositories/match_contact_repository.dart';

abstract interface class IGetOrCreateChatForContact {
  Future<Chat?> call(
    CustomerModel customer, {
    String? immobileListingId,
  });
}

class GetOrCreateChatForContact implements IGetOrCreateChatForContact {
  final IMatchContactRepository repository;

  const GetOrCreateChatForContact(this.repository);

  @override
  Future<Chat?> call(
    CustomerModel customer, {
    String? immobileListingId,
  }) {
    return repository.getOrCreateChatForContact(
      customer,
      immobileListingId: immobileListingId,
    );
  }
}
