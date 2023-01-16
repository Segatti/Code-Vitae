import 'dart:convert';

import 'package:dartz/dartz.dart' as dartz;
import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:modular_test/modular_test.dart';
import 'package:morty_verso/app/modules/characters/characters_module.dart';
import 'package:morty_verso/app/modules/characters/domain/entities/character.dart';
import 'package:morty_verso/app/modules/characters/domain/entities/characters.dart';
import 'package:morty_verso/app/modules/characters/domain/usecases/get_all_characters.dart';
import 'package:morty_verso/app/modules/characters/domain/usecases/get_one_character.dart';

import '../../utils/json_response.dart';
import 'characters_module_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  final dio = MockDio();

  initModule(
    CharactersModule(),
    replaceBinds: [
      Bind.singleton((i) => dio),
    ],
  );

  /// Só caso de sucesso, pois as todas as falhas ja são testadas em outros arquivos

  group('Sucessos', () {
    test('Buscar todos os personagens', () async {
      when(dio.get(any)).thenAnswer(
        (_) async => Response(
          data: jsonDecode(allCharacters),
          statusCode: 200,
          requestOptions: RequestOptions(
            path: '',
          ),
        ),
      );

      final usecase = Modular.get<IUCGetAllCharacters>();
      final result = await usecase(1);

      expect(result, isA<dartz.Right>());
      expect(result.fold((l) => l, (r) => r), isA<Characters>());
    });

    test('Buscar um personagem', () async {
      when(dio.get(any)).thenAnswer(
        (_) async => Response(
          data: jsonDecode(oneCharacter),
          statusCode: 200,
          requestOptions: RequestOptions(
            path: '',
          ),
        ),
      );

      final usecase = Modular.get<IUCGetOneCharacter>();
      final result = await usecase(1);

      expect(result, isA<dartz.Right>());
      expect(result.fold((l) => l, (r) => r), isA<Character>());
    });
  });
}
