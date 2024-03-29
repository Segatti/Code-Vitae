// Mocks generated by Mockito 5.4.2 from annotations
// in morty_verso/test/app/modules/locations/infra/repositories/location_repository_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i6;

import 'package:dio/dio.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:morty_verso/app/modules/locations/external/rick_morty_api/rick_morty_datasource.dart'
    as _i5;
import 'package:morty_verso/app/modules/locations/infra/models/location_model.dart'
    as _i4;
import 'package:morty_verso/app/modules/locations/infra/models/locations_model.dart'
    as _i3;

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

class _FakeDio_0 extends _i1.SmartFake implements _i2.Dio {
  _FakeDio_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeLocationsModel_1 extends _i1.SmartFake
    implements _i3.LocationsModel {
  _FakeLocationsModel_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeLocationModel_2 extends _i1.SmartFake implements _i4.LocationModel {
  _FakeLocationModel_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [RickMortyDatasource].
///
/// See the documentation for Mockito's code generation for more information.
class MockRickMortyDatasource extends _i1.Mock
    implements _i5.RickMortyDatasource {
  MockRickMortyDatasource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get urlApi => (super.noSuchMethod(
        Invocation.getter(#urlApi),
        returnValue: '',
      ) as String);

  @override
  _i2.Dio get dio => (super.noSuchMethod(
        Invocation.getter(#dio),
        returnValue: _FakeDio_0(
          this,
          Invocation.getter(#dio),
        ),
      ) as _i2.Dio);

  @override
  _i6.Future<_i3.LocationsModel> getAll(int? page) => (super.noSuchMethod(
        Invocation.method(
          #getAll,
          [page],
        ),
        returnValue: _i6.Future<_i3.LocationsModel>.value(_FakeLocationsModel_1(
          this,
          Invocation.method(
            #getAll,
            [page],
          ),
        )),
      ) as _i6.Future<_i3.LocationsModel>);

  @override
  _i6.Future<_i4.LocationModel> getOne(int? id) => (super.noSuchMethod(
        Invocation.method(
          #getOne,
          [id],
        ),
        returnValue: _i6.Future<_i4.LocationModel>.value(_FakeLocationModel_2(
          this,
          Invocation.method(
            #getOne,
            [id],
          ),
        )),
      ) as _i6.Future<_i4.LocationModel>);

  @override
  _i6.Future<List<_i4.LocationModel>> getMultiple(List<int>? ids) =>
      (super.noSuchMethod(
        Invocation.method(
          #getMultiple,
          [ids],
        ),
        returnValue:
            _i6.Future<List<_i4.LocationModel>>.value(<_i4.LocationModel>[]),
      ) as _i6.Future<List<_i4.LocationModel>>);
}
