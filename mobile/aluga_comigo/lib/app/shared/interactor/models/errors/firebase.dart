abstract class FirebaseError {
  final String? code;
  final String msg;

  const FirebaseError({this.code, required this.msg});
}

class FirebaseAuthError extends FirebaseError {
  FirebaseAuthError({super.code, required super.msg});
}

class FirebaseDatabaseError extends FirebaseError {
  FirebaseDatabaseError({super.code, required super.msg});
}

class FirebaseStorageError extends FirebaseError {
  FirebaseStorageError({super.code, required super.msg});
}
