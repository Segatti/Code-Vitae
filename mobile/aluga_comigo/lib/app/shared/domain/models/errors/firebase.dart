import '../../entities/failures.dart';

abstract class FirebaseError extends FailureDatasource {
  FirebaseError({required super.message});
}

class FirebaseAuthError extends FirebaseError {
  FirebaseAuthError({required super.message});
}

class FirebaseDatabaseError extends FirebaseError {
  FirebaseDatabaseError({required super.message});
}

class FirebaseStorageError extends FirebaseError {
  FirebaseStorageError({required super.message});
}
