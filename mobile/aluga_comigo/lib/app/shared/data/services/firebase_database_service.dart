import 'dart:async';

import 'package:aluga_comigo/app/shared/domain/models/errors/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

enum FirebaseDataTables {
  users,
  immobile,
}

class FirebaseDatabaseService {
  final FirebaseFirestore _firebase;

  FirebaseDatabaseService(this._firebase);

  Future<Either<FirebaseDatabaseError, void>> create(
    FirebaseDataTables table,
    Map<String, dynamic> data,
  ) async {
    try {
      var id = data.remove('id');
      var ref = _firebase.collection(table.name);
      await ref.doc(id).set(data);
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
      var ref = _firebase.collection(table.name);
      final data = await ref.doc(path).get();
      return Right(data.data());
    } catch (exception) {
      final error = FirebaseDatabaseError(
        msg: exception.toString(),
      );

      return Left(error);
    }
  }

  Future<Either<FirebaseDatabaseError, Stream>> listen(
    FirebaseDataTables table,
    String? path,
  ) async {
    try {
      if (path != null) {
        var ref = _firebase.collection(table.name).doc(path).snapshots();
        return Right(ref);
      } else {
        var ref = _firebase.collection(table.name).snapshots();
        return Right(ref);
      }
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
      var ref = _firebase.collection(table.name).doc(path);
      await ref.set(data);
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
      var ref = _firebase.collection(table.name).doc(path);
      await ref.delete();
      return const Right(null);
    } catch (exception) {
      final error = FirebaseDatabaseError(
        msg: exception.toString(),
      );

      return Left(error);
    }
  }
}
