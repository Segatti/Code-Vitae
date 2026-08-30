import 'dart:developer';

import 'package:material_ui/material_ui.dart';

import '../typedefs/returns.dart';

extension ListMapToObject on List<dynamic>? {
  List<T> toListObject<T>(T Function(Json map) fromMap) {
    try {
      return this
              ?.map((dynamic x) => fromMap(x as Json? ?? <String, dynamic>{}))
              .toList()
              .cast() ??
          <T>[];
    } catch (e) {
      debugPrint(e.toString());
      return <T>[];
    }
  }
}

extension MapConvertExt on Json {
  List<T> getList<T>(String key) {
    try {
      if (this[key] is List) {
        // ignore: always_specify_types
        final result = (this[key] as List).map((i) => i as T?).toList();
        result.removeWhere((T? i) => i == null);
        return result.cast<T>();
      } else {
        return <T>[];
      }
    } catch (e) {
      debugPrint(e.toString());
      return <T>[];
    }
  }

  T getSafe<T>(String key) {
    try {
      final dynamic value = this[key];
      if (value == null) {
        if (T == String) return '' as T;
        if (T == num) return 0 as T;
        if (T == int) return 0 as T;
        if (T == double) return 0.0 as T;
        if (T == bool) return false as T;
        if (T == List) return <dynamic>[] as T;
        if (T == Json) return Json() as T;
        return value as T;
      }

      return value as T;
    } catch (error) {
      if (error is TypeError) {
        log("Erro tipo em $key: $error");
        if (T == String) return '' as T;
        if (T == num) return 0 as T;
        if (T == int) return 0 as T;
        if (T == double) return 0.0 as T;
        if (T == bool) return false as T;
        if (T == List) return <dynamic>[] as T;
        if (T == Json) return Json() as T;
        rethrow;
      } else {
        rethrow;
      }
    }
  }
}

extension ObjectToMap on List<Object> {
  List<Map<String, dynamic>> toMapList() {
    return map((Object e) => (e as dynamic).toMap()).toList().cast<Json>();
  }
}
