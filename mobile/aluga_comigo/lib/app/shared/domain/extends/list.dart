import 'package:flutter/material.dart';

import '../typedefs/returns.dart';


// ignore: always_specify_types
extension ListExt on List {
  T? safeGet<T>(int index) {
    if (index >= length) {
      return null;
    }
    return this[index];
  }

  T? safeRemove<T>(int index) {
    if (index >= length) {
      return null;
    }
    return removeAt(index);
  }

  T reduceSafe<T>(T Function(T value, T element) combine) {
    try {
      if (isEmpty) {
        return getType<T>();
      }
      return fold<T>(
        getType<T>(),
        (T previousValue, dynamic element) =>
            combine(previousValue, element as T),
      );
    } catch (e) {
      debugPrint(e.toString());
      return getType<T>();
    }
  }
}

T getType<T>() {
  if (T == String) {
    return '' as T;
  } else if (T == int) {
    return 0 as T;
  } else if (T == double) {
    return 0 as T;
  } else if (T == bool) {
    return false as T;
  } else if (T == List) {
    return <dynamic>[] as T;
  } else if (T == Json) {
    return Json() as T;
  } else {
    throw Exception('Type not supported');
  }
}

// ignore: always_specify_types
extension IterableExt on Iterable {
  T? safeGet<T>(int index) {
    if (index >= length) {
      return null;
    }
    return toList()[index];
  }

  T? safeRemove<T>(int index) {
    if (index >= length) {
      return null;
    }
    return toList().removeAt(index);
  }

  T reduceSafe<T>(T Function(T value, T element) combine) {
    try {
      if (isEmpty) {
        return getType<T>();
      }
      return fold<T>(
        getType<T>(),
        (T previousValue, dynamic element) =>
            combine(previousValue, element as T),
      );
    } catch (e) {
      debugPrint(e.toString());
      return getType<T>();
    }
  }
}
