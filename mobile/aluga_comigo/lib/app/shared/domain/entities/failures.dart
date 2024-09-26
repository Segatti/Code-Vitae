abstract class Failure implements Exception {
  final String origin;
  final String message;

  Failure({
    required this.origin,
    required this.message,
  });
}

class FailureDatasource extends Failure {
  FailureDatasource({required super.message}) : super(origin: "Datasource");
}

class FailureRepository extends Failure {
  FailureRepository({required super.message}) : super(origin: "Repository");
}

class FailureUseCase extends Failure {
  FailureUseCase({required super.message}) : super(origin: "Use Case");
}
