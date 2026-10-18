import 'package:dartz/dartz.dart';

import '../../domain/entities/failures.dart';
import '../../domain/repositories/terms_acceptance_repository.dart';
import '../../domain/typedefs/returns.dart';
import '../services/supabase_database_service.dart';

class TermsAcceptanceRepository implements ITermsAcceptanceRepository {
  const TermsAcceptanceRepository(this._database);

  final SupabaseDatabaseService _database;

  @override
  Future<Return<String?>> getAcceptedVersion(String accountId) async {
    try {
      final version = await _database.getTermsOfUseAcceptedVersion(accountId);
      return Right(version);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(FailureRepository(message: e.toString()));
    }
  }

  @override
  Future<Return<void>> recordAcceptance(String version) async {
    try {
      await _database.acceptTermsOfUse(version);
      return const Right(null);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(FailureRepository(message: e.toString()));
    }
  }
}
