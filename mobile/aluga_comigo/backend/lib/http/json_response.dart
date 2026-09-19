import 'dart:convert';

import 'package:shelf/shelf.dart';

Response jsonResponse(int statusCode, Object? body) {
  return Response(
    statusCode,
    body: jsonEncode(body),
    headers: {
      'content-type': 'application/json; charset=utf-8',
    },
  );
}

Response jsonError(int statusCode, String message) {
  return jsonResponse(statusCode, {'error': message});
}
