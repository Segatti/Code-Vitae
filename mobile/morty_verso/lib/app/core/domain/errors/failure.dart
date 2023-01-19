import 'dart:developer';

class Failure implements Exception {
  String message;
  Failure(this.message) {
    log("Error: $message");
  }
}
