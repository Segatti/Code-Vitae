import '../../../../core/domain/errors/failure.dart';

class InvalidInput extends Failure {}

class EmptyList extends Failure {}

class InfraError extends Failure {}

class DatasourceError extends Failure {}