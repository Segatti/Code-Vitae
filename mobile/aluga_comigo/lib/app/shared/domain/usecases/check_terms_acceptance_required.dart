import 'package:dartz/dartz.dart';

import '../repositories/terms_acceptance_repository.dart';
import '../typedefs/returns.dart';

abstract interface class ICheckTermsAcceptanceRequired {
  Future<Return<bool>> call({
    required String accountId,
    required String currentVersion,
  });
}

class CheckTermsAcceptanceRequired implements ICheckTermsAcceptanceRequired {
  const CheckTermsAcceptanceRequired(this._repository);

  final ITermsAcceptanceRepository _repository;

  @override
  Future<Return<bool>> call({
    required String accountId,
    required String currentVersion,
  }) async {
    final acceptedResult = await _repository.getAcceptedVersion(accountId);
    return acceptedResult.fold(
      Left.new,
      (accepted) => Right(accepted != currentVersion),
    );
  }
}
