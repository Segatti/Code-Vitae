import '../typedefs/returns.dart';

abstract interface class ITermsAcceptanceRepository {
  Future<Return<String?>> getAcceptedVersion(String accountId);

  Future<Return<void>> recordAcceptance(String version);
}
