import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:morty_verso/app/modules/characters/external/rick_morty_api/rick_morty_datasource.dart';
import 'package:morty_verso/app/modules/characters/infra/models/characters_model.dart';

import 'rick_morty_datasource_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  final dio = MockDio();
  final datasource = RickMortyDatasource(dio: dio);

  test('Deve retornar 200 na API', () async {
    when(dio.get(any)).thenAnswer(
      (_) async => Response(
        data: jsonDecode(jsonResponse),
        statusCode: 200,
        requestOptions: RequestOptions(path: ''),
      ),
    );
    expect(await datasource.getAll(1), isA<CharactersModel>());
  });
}

var jsonResponse = """
{
  "info": {
    "count": 826,
    "pages": 42,
    "next": "https://rickandmortyapi.com/api/character/?page=2",
    "prev": null
  },
  "results": [
    {
      "id": 1,
      "name": "Rick Sanchez",
      "status": "Alive",
      "species": "Human",
      "type": "",
      "gender": "Male",
      "origin": {
        "name": "Earth",
        "url": "https://rickandmortyapi.com/api/location/1"
      },
      "location": {
        "name": "Earth",
        "url": "https://rickandmortyapi.com/api/location/20"
      },
      "image": "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
      "episode": [
        "https://rickandmortyapi.com/api/episode/1",
        "https://rickandmortyapi.com/api/episode/2"
      ],
      "url": "https://rickandmortyapi.com/api/character/1",
      "created": "2017-11-04T18:48:46.250Z"
    }
  ]
}
""";
