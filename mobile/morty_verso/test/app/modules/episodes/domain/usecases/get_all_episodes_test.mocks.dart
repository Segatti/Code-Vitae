// Mocks generated by Mockito 5.4.2 from annotations
// in morty_verso/test/app/modules/episodes/domain/usecases/get_all_episodes_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:dartz/dartz.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;
import 'package:morty_verso/app/core/domain/errors/failure.dart' as _i6;
import 'package:morty_verso/app/modules/episodes/domain/entities/episode.dart'
    as _i8;
import 'package:morty_verso/app/modules/episodes/domain/entities/episodes.dart'
    as _i7;
import 'package:morty_verso/app/modules/episodes/infra/datasources/api_datasource.dart'
    as _i2;
import 'package:morty_verso/app/modules/episodes/infra/repositories/episode_repository.dart'
    as _i4;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeIApiDatasource_0 extends _i1.SmartFake
    implements _i2.IApiDatasource {
  _FakeIApiDatasource_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeEither_1<L, R> extends _i1.SmartFake implements _i3.Either<L, R> {
  _FakeEither_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [EpisodeRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockEpisodeRepository extends _i1.Mock implements _i4.EpisodeRepository {
  MockEpisodeRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.IApiDatasource get apiDatasource => (super.noSuchMethod(
        Invocation.getter(#apiDatasource),
        returnValue: _FakeIApiDatasource_0(
          this,
          Invocation.getter(#apiDatasource),
        ),
      ) as _i2.IApiDatasource);

  @override
  _i5.Future<_i3.Either<_i6.Failure, _i7.Episodes>> getAll(int? page) =>
      (super.noSuchMethod(
        Invocation.method(
          #getAll,
          [page],
        ),
        returnValue: _i5.Future<_i3.Either<_i6.Failure, _i7.Episodes>>.value(
            _FakeEither_1<_i6.Failure, _i7.Episodes>(
          this,
          Invocation.method(
            #getAll,
            [page],
          ),
        )),
      ) as _i5.Future<_i3.Either<_i6.Failure, _i7.Episodes>>);

  @override
  _i5.Future<_i3.Either<_i6.Failure, _i8.Episode>> getOne(int? id) =>
      (super.noSuchMethod(
        Invocation.method(
          #getOne,
          [id],
        ),
        returnValue: _i5.Future<_i3.Either<_i6.Failure, _i8.Episode>>.value(
            _FakeEither_1<_i6.Failure, _i8.Episode>(
          this,
          Invocation.method(
            #getOne,
            [id],
          ),
        )),
      ) as _i5.Future<_i3.Either<_i6.Failure, _i8.Episode>>);

  @override
  _i5.Future<_i3.Either<_i6.Failure, List<_i8.Episode>>> getMultiple(
          List<int>? ids) =>
      (super.noSuchMethod(
        Invocation.method(
          #getMultiple,
          [ids],
        ),
        returnValue:
            _i5.Future<_i3.Either<_i6.Failure, List<_i8.Episode>>>.value(
                _FakeEither_1<_i6.Failure, List<_i8.Episode>>(
          this,
          Invocation.method(
            #getMultiple,
            [ids],
          ),
        )),
      ) as _i5.Future<_i3.Either<_i6.Failure, List<_i8.Episode>>>);
}
