import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:material_ui/material_ui.dart';

import '../../domain/entities/failures.dart';
import '../../domain/errors/firebase_error_handler.dart';
import '../../domain/models/errors/firebase.dart';

enum FirebaseStorageTables {
  users,
}

class FirebaseStorageService {
  final FirebaseStorage _firebase;

  const FirebaseStorageService(this._firebase);

  Future<Either<FirebaseStorageError, String>> upload(
    FirebaseStorageTables table,
    String? path,
    File file,
  ) async {
    try {
      final ref = _firebase.ref("${table.name}/${path ?? ''}");

      await ref.putFile(
        file,
        SettableMetadata(
          contentType: "image/jpeg",
        ),
      );
      final String link = await ref.getDownloadURL();
      return Right(link);
    } on FirebaseException catch (error) {
      debugPrint(error.toString());
      throw FailureDatasource(
        message: FirebaseErrorHandler.getMessage(error.code),
      );
    } catch (exception) {
      final error = FirebaseStorageError(
        message: exception.toString(),
      );

      return Left(error);
    }
  }
}
