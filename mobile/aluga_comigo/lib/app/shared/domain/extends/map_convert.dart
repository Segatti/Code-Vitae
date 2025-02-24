import 'package:flutter/material.dart';

import '../typedefs/returns.dart';

extension ListMapToObject on List? {
  List<T> toListObject<T>(T Function(Json map) fromMap) {
    try {
      return this?.map((x) => fromMap(x ?? {})).toList().cast() ?? [];
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }
}
