import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum StorageKey {
  intro,
  userEmail,
  userPassword,
}

class SecureStorageService {
  final FlutterSecureStorage _storage;

  const SecureStorageService(this._storage);

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
        resetOnError: true,
      );

  Future<String?> getData(StorageKey key) async {
    return await _storage.read(
      key: key.name,
      aOptions: _getAndroidOptions(),
    );
  }

  Future<void> setData(StorageKey key, String value) async {
    await _storage.write(
      key: key.name,
      value: value,
      aOptions: _getAndroidOptions(),
    );
  }

  Future<void> deleteData(StorageKey key) async {
    await _storage.delete(
      key: key.name,
      aOptions: _getAndroidOptions(),
    );
    bool hasKey = await _storage.containsKey(
      key: key.name,
      aOptions: _getAndroidOptions(),
    );
    if (hasKey) {
      throw Exception("Falhou ao tentar deletar ${key.name}");
    }
  }

  Future<void> showStorage() async {
    Map data = await _storage.readAll(
      aOptions: _getAndroidOptions(),
    );
    log(data.toString());
  }

  Future<void> clearData(StorageKey key) async {
    await _storage.deleteAll(
      aOptions: _getAndroidOptions(),
    );
  }
}
