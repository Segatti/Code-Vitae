// import 'package:result_dart/result_dart.dart';

import 'package:flutter/foundation.dart';
import 'package:result_dart/result_dart.dart'
    hide FutureResultExtension, FutureResultExtensionVoid;

import '../errors/failure.dart' as error;

extension AsyncResultReturn<T extends Object> on Future<T> {
  AsyncResult<T> toAsyncResult() async {
    try {
      final result = await this;
      return Success(result);
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
      if (e is error.Failure) {
        return Failure(e);
      }
      return Failure(Exception(e.toString()));
    }
  }
}

extension AsyncResultReturnVoid on Future<void> {
  AsyncResult<Unit> toAsyncResult() async {
    try {
      await this;
      return Success(unit);
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
      if (e is error.Failure) {
        return Failure(e);
      }
      return Failure(Exception(e.toString()));
    }
  }
}
