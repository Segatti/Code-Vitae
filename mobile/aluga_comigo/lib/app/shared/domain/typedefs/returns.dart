import 'package:aluga_comigo/app/shared/domain/entities/failures.dart';
import 'package:dartz/dartz.dart';

export 'json.dart';

typedef Return<T> = Either<Failure, T>;