import 'failure.dart';

class KeyError extends Failure {
  KeyError(String message): super(message);
}

class ItemValueError extends Failure {
  ItemValueError(String message): super(message);
}

class ServiceError extends Failure {
  ServiceError(String message): super(message);
}