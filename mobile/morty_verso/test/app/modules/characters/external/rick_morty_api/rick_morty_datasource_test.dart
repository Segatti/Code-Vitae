import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:morty_verso/app/modules/characters/external/rick_morty_api/rick_morty_datasource.dart';
import 'package:morty_verso/app/modules/characters/infra/models/character_model.dart';
import 'package:morty_verso/app/modules/characters/infra/models/characters_model.dart';

import '../../../../utils/json_response.dart';
import 'rick_morty_datasource_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  final dio = MockDio();
  final datasource = RickMortyDatasource(dio: dio);

  group('Sucessos', () {
    test('Deve retornar 200 na API quando buscar todos os personagens',
        () async {
      when(dio.get(any)).thenAnswer(
        (_) async => Response(
          data: jsonDecode(allCharacters),
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );
      expect(await datasource.getAll(1), isA<CharactersModel>());
    });

    test('Deve retornar 200 na API quando buscar um personagem',
        () async {
      when(dio.get(any)).thenAnswer(
        (_) async => Response(
          data: jsonDecode(oneCharacter),
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );
      expect(await datasource.getOne(1), isA<CharacterModel>());
    });
  });

  group('Erros', () {
    test('Erro na API quando buscar todos os personagens', () async {
      try {
        when(dio.get(any)).thenAnswer(
          (_) async => Response(
            data: null,
            statusCode: 400,
            requestOptions: RequestOptions(path: ''),
          ),
        );
        await datasource.getAll(1);
      } catch (e) {
        expect(e, isA<Exception>());
      }
    });

    test('Erro na API quando buscar um personagem', () async {
      try {
        when(dio.get(any)).thenAnswer(
          (_) async => Response(
            data: null,
            statusCode: 400,
            requestOptions: RequestOptions(path: ''),
          ),
        );
        await datasource.getOne(1);
      } catch (e) {
        expect(e, isA<Exception>());
      }
    });
  });
}
