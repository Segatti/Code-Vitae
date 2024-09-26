import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/failures.dart';
import '../../domain/typedefs/returns.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebase;

  const FirebaseAuthService(this._firebase);

  Future<Return<UserCredential>> login(
    String email,
    String password,
  ) async {
    try {
      final UserCredential data = await _firebase.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(data);
    } catch (exception) {
      return Left(
        FailureDatasource(message: exception.toString()),
      );
    }
  }

  Future<Return<UserCredential>> createUser(
    String email,
    String password,
  ) async {
    try {
      final UserCredential data =
          await _firebase.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(data);
    } catch (exception) {
      return Left(
        FailureDatasource(message: exception.toString()),
      );
    }
  }

  Future<Return<bool>> logout(
    String email,
    String password,
  ) async {
    try {
      await _firebase.signOut();
      return const Right(true);
    } catch (exception) {
      return Left(
        FailureDatasource(
          message: exception.toString(),
        ),
      );
    }
  }

  Future<Return<bool>> recoverPassword(
    String email,
  ) async {
    try {
      await _firebase.sendPasswordResetEmail(email: email);
      return const Right(true);
    } catch (exception) {
      return Left(
        FailureDatasource(message: exception.toString()),
      );
    }
  }
}
