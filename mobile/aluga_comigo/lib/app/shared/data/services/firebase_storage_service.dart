import 'dart:io';

import 'package:aluga_comigo/app/shared/interactor/models/errors/firebase.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';

enum FirebaseStorageTables {
  users,
  houses,
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
    } catch (exception) {
      final error = FirebaseStorageError(
        msg: exception.toString(),
      );

      return Left(error);
    }
  }
}
