import 'dart:async';

import 'package:aluga_comigo/app/shared/interactor/models/errors/firebase.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_database/firebase_database.dart';

enum FirebaseDataTables {
  users,
  immobile,
}

class FirebaseDatabaseService {
  final FirebaseDatabase _firebase;

  FirebaseDatabaseService(this._firebase) {
    _firebase.setPersistenceEnabled(true);
  }

  Future<Either<FirebaseDatabaseError, void>> create(
    FirebaseDataTables table,
    Map<String, dynamic> data,
  ) async {
    try {
      DatabaseReference ref = _firebase.ref(table.name);
      await ref.set(data);
      return const Right(null);
    } catch (exception) {
      final error = FirebaseDatabaseError(
        msg: exception.toString(),
      );

      return Left(error);
    }
  }

  Future<Either<FirebaseDatabaseError, dynamic>> read(
    FirebaseDataTables table,
    String path,
  ) async {
    try {
      DatabaseReference ref = _firebase.ref(table.name);
      final data = await ref.child(path).get();
      return Right(data.value);
    } catch (exception) {
      final error = FirebaseDatabaseError(
        msg: exception.toString(),
      );

      return Left(error);
    }
  }

  Future<Either<FirebaseDatabaseError, Stream<DatabaseEvent>>> listen(
    FirebaseDataTables table,
    String? path,
  ) async {
    try {
      DatabaseReference ref = _firebase.ref("${table.name}/${path ?? ''}");
      return Right(ref.onValue);
    } catch (exception) {
      final error = FirebaseDatabaseError(
        msg: exception.toString(),
      );

      return Left(error);
    }
  }

  Future<Either<FirebaseDatabaseError, dynamic>> update(
    FirebaseDataTables table,
    String path,
    Map<String, dynamic> data,
  ) async {
    try {
      DatabaseReference ref = _firebase.ref("${table.name}/$path");
      await ref.update(data);
      return const Right(null);
    } catch (exception) {
      final error = FirebaseDatabaseError(
        msg: exception.toString(),
      );

      return Left(error);
    }
  }

  Future<Either<FirebaseDatabaseError, dynamic>> delete(
    FirebaseDataTables table,
    String path,
  ) async {
    try {
      DatabaseReference ref = _firebase.ref("${table.name}/$path");
      await ref.remove();
      return const Right(null);
    } catch (exception) {
      final error = FirebaseDatabaseError(
        msg: exception.toString(),
      );

      return Left(error);
    }
  }
}
