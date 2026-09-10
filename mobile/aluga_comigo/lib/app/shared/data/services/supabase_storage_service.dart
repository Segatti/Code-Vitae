import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:material_ui/material_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/failures.dart';
import '../../domain/errors/supabase_error_handler.dart';

enum StorageBuckets {
  avatars,
}

class SupabaseStorageService {
  final SupabaseClient _client;

  const SupabaseStorageService(this._client);

  Future<Either<FailureDatasource, String>> upload(
    StorageBuckets bucket,
    String path,
    File file,
  ) async {
    try {
      await _client.storage.from(bucket.name).upload(
            path,
            file,
            fileOptions: const FileOptions(
              upsert: true,
              contentType: 'image/jpeg',
            ),
          );

      final url = _client.storage.from(bucket.name).getPublicUrl(path);
      return Right(url);
    } on StorageException catch (error) {
      debugPrint(error.toString());
      throw FailureDatasource(
        message: SupabaseErrorHandler.getMessage(error.statusCode, error.message),
      );
    } catch (error) {
      return Left(FailureDatasource(message: error.toString()));
    }
  }
}
