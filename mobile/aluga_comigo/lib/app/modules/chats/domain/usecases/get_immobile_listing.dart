import 'package:result_dart/result_dart.dart';

import '../../../customer/data/models/customer_model.dart';
import '../repositories/chat_repository.dart';

abstract interface class IGetImmobileListing {
  AsyncResult<ImmobileCustomerModel> call(String listingId);
}

class GetImmobileListing implements IGetImmobileListing {
  final IChatRepository repository;

  const GetImmobileListing(this.repository);

  @override
  AsyncResult<ImmobileCustomerModel> call(String listingId) {
    if (listingId.trim().isEmpty) {
      return Future.value(Failure(Exception('Imóvel inválido')));
    }
    return repository.getImmobileListing(listingId);
  }
}
