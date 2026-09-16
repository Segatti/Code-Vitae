import 'package:result_dart/result_dart.dart';

import '../../data/models/customer_model.dart';
import '../../data/repositories/customer_repository.dart';

abstract interface class IMatchImmobileWithSuperChat {
  AsyncResult<Unit> call({
    required ImmobileCustomerModel immobile,
    required String message,
  });
}

class MatchImmobileWithSuperChat implements IMatchImmobileWithSuperChat {
  final ICustomerRepository repository;

  const MatchImmobileWithSuperChat(this.repository);

  @override
  AsyncResult<Unit> call({
    required ImmobileCustomerModel immobile,
    required String message,
  }) {
    return repository.matchImmobileWithSuperChat(
      immobile: immobile,
      message: message,
    );
  }
}
