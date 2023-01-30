import '../../../../core/domain/errors/failure.dart';

class InvalidInput extends Failure {
  InvalidInput(String message):super(message);
}

class EmptyList extends Failure {
  EmptyList(String message):super(message);
}

class DatasourceError extends Failure {
  DatasourceError(String message):super(message);
}