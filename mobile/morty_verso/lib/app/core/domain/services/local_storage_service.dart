abstract class ILocalStorageService {
  dynamic get(String key);
  void set(String key, String json);
}
