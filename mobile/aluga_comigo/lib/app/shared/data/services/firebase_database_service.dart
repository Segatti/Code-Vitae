import 'dart:async';

import 'package:aluga_comigo/app/shared/domain/models/errors/firebase.dart';
import 'package:aluga_comigo/app/shared/domain/typedefs/returns.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:material_ui/material_ui.dart';

import '../../domain/entities/failures.dart';
import '../../domain/errors/firebase_error_handler.dart';

enum FirebaseDataTables {
  users,
  immobiles,
  chats,
  matchTo, // from user to person
  matchFrom, // from person to user
}

class FirebaseDatabaseService {
  final FirebaseFirestore _firebase;

  FirebaseDatabaseService(this._firebase);

  CollectionReference<Json> getRef(FirebaseDataTables table) {
    try {
      var ref = _firebase.collection(table.name);
      return ref;
    } on FirebaseException catch (error) {
      debugPrint(error.toString());
      throw FailureDatasource(
        message: FirebaseErrorHandler.getMessage(error.code),
      );
    } catch (exception) {
      final error = FirebaseDatabaseError(message: exception.toString());

      throw error;
    }
  }

  Future<Either<FirebaseDatabaseError, void>> create(
    FirebaseDataTables table,
    Map<String, dynamic> data,
  ) async {
    try {
      var id = data['id'];
      var ref = _firebase.collection(table.name);
      id ??= ref.doc().id;
      await ref.doc(id).set({...data, 'id': id}, SetOptions(merge: true));
      return const Right(null);
    } on FirebaseException catch (error) {
      debugPrint(error.toString());
      throw FailureDatasource(
        message: FirebaseErrorHandler.getMessage(error.code),
      );
    } catch (exception) {
      final error = FirebaseDatabaseError(message: exception.toString());

      return Left(error);
    }
  }

  Future<Either<FirebaseDatabaseError, Json>> read(
    FirebaseDataTables table,
    String path,
  ) async {
    try {
      var ref = _firebase.collection(table.name);
      final data = await ref.doc(path).get();
      return Right(data.data() ?? {});
    } on FirebaseException catch (error) {
      debugPrint(error.toString());
      throw FailureDatasource(
        message: FirebaseErrorHandler.getMessage(error.code),
      );
    } catch (exception) {
      final error = FirebaseDatabaseError(message: exception.toString());

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
    } on FirebaseException catch (error) {
      debugPrint(error.toString());
      throw FailureDatasource(
        message: FirebaseErrorHandler.getMessage(error.code),
      );
    } catch (exception) {
      final error = FirebaseDatabaseError(message: exception.toString());

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
      await ref.set(data, SetOptions(merge: true));
      return const Right(null);
    } on FirebaseException catch (error) {
      debugPrint(error.toString());
      throw FailureDatasource(
        message: FirebaseErrorHandler.getMessage(error.code),
      );
    } catch (exception) {
      final error = FirebaseDatabaseError(message: exception.toString());

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
    } on FirebaseException catch (error) {
      debugPrint(error.toString());
      throw FailureDatasource(
        message: FirebaseErrorHandler.getMessage(error.code),
      );
    } catch (exception) {
      final error = FirebaseDatabaseError(message: exception.toString());

      return Left(error);
    }
  }
}
