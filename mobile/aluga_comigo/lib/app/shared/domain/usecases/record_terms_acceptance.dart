import '../repositories/terms_acceptance_repository.dart';
import '../typedefs/returns.dart';

abstract interface class IRecordTermsAcceptance {
  Future<Return<void>> call(String version);
}

class RecordTermsAcceptance implements IRecordTermsAcceptance {
  const RecordTermsAcceptance(this._repository);

  final ITermsAcceptanceRepository _repository;

  @override
  Future<Return<void>> call(String version) {
    return _repository.recordAcceptance(version);
  }
}
