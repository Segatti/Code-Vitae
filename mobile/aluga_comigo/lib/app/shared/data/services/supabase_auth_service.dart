import 'package:dartz/dartz.dart';
import 'package:material_ui/material_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/failures.dart';
import '../../domain/errors/supabase_error_handler.dart';
import '../../domain/typedefs/returns.dart';

class SupabaseAuthService {
  final SupabaseClient _client;

  const SupabaseAuthService(this._client);

  Future<Return<AuthResponse>> login(String email, String password) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return Right(response);
    } on AuthException catch (error) {
      debugPrint(error.toString());
      throw FailureDatasource(
        message: SupabaseErrorHandler.getMessage(error.code, error.message),
      );
    } catch (error) {
      return Left(FailureDatasource(message: error.toString()));
    }
  }

  Future<Return<AuthResponse>> createUser(String email, String password) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );
      return Right(response);
    } on AuthException catch (error) {
      debugPrint(error.toString());
      throw FailureDatasource(
        message: SupabaseErrorHandler.getMessage(error.code, error.message),
      );
    } catch (error) {
      return Left(FailureDatasource(message: error.toString()));
    }
  }

  Future<void> deleteCurrentUser() async {
    try {
      await _client.rpc('delete_own_account');
    } on AuthException catch (error) {
      debugPrint(error.toString());
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<Return<bool>> recoverPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
      return const Right(true);
    } on AuthException catch (error) {
      debugPrint(error.toString());
      throw FailureDatasource(
        message: SupabaseErrorHandler.getMessage(error.code, error.message),
      );
    } catch (error) {
      return Left(FailureDatasource(message: error.toString()));
    }
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}
