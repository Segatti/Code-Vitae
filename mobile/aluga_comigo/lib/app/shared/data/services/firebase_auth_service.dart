import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebase;

  const FirebaseAuthService(this._firebase);

  Future<Either<FirebaseAuthException, UserCredential>> login(
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
      if (exception is FirebaseAuthException) {
        return Left(exception);
      } else {
        return Left(
          FirebaseAuthException(
            code: "-1",
            message: exception.toString(),
          ),
        );
      }
    }
  }

  Future<Either<FirebaseAuthException, UserCredential>> createUser(
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
      if (exception is FirebaseAuthException) {
        return Left(exception);
      } else {
        return Left(
          FirebaseAuthException(
            code: "-1",
            message: exception.toString(),
          ),
        );
      }
    }
  }

  Future<Either<FirebaseAuthException, void>> logout(
    String email,
    String password,
  ) async {
    try {
      await _firebase.signOut();
      return const Right(null);
    } catch (exception) {
      if (exception is FirebaseAuthException) {
        return Left(exception);
      } else {
        return Left(
          FirebaseAuthException(
            code: "-1",
            message: exception.toString(),
          ),
        );
      }
    }
  }

  Future<Either<FirebaseAuthException, void>> recoverPassword(
    String email,
  ) async {
    try {
      await _firebase.sendPasswordResetEmail(email: email);
      return const Right(null);
    } catch (exception) {
      if (exception is FirebaseAuthException) {
        return Left(exception);
      } else {
        return Left(
          FirebaseAuthException(
            code: "-1",
            message: exception.toString(),
          ),
        );
      }
    }
  }
}
