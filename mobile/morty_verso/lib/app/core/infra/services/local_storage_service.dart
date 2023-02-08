import 'package:localstorage/localstorage.dart';
import 'package:morty_verso/app/core/domain/services/local_storage_service.dart';

class LocalStorageService implements ILocalStorageService {
  final LocalStorage localStorage;

  const LocalStorageService(this.localStorage);

  @override
  get(dynamic key) {
    try {
      return localStorage.getItem(key);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  void set(String key, dynamic json) {
    localStorage.setItem(key, json);
  }
}
