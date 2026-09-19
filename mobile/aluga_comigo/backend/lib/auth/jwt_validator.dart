import 'dart:convert';
import 'dart:io';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class JwtValidator {
  JwtValidator._(this._jwtSecret, this._jwksByKid);

  final String _jwtSecret;
  final Map<String, JWTKey> _jwksByKid;

  static Future<JwtValidator> create({
    required String jwtSecret,
    required String supabaseUrl,
  }) async {
    final jwksByKid = await _fetchJwks(supabaseUrl);
    if (jwksByKid.isEmpty) {
      stderr.writeln(
        'Aviso: JWKS vazio — tokens ES256 do Supabase não serão aceitos. '
        'Confira SUPABASE_URL e se o Auth está no ar.',
      );
    }
    return JwtValidator._(jwtSecret, jwksByKid);
  }

  static Future<Map<String, JWTKey>> _fetchJwks(String supabaseUrl) async {
    final base = supabaseUrl.replaceAll(RegExp(r'/+$'), '');
    final uri = Uri.parse('$base/auth/v1/.well-known/jwks.json');
    final client = HttpClient();
    try {
      final request = await client.getUrl(uri);
      final response = await request.close();
      if (response.statusCode != 200) {
        stderr.writeln('JWKS HTTP ${response.statusCode} em $uri');
        return {};
      }
      final body = await response.transform(utf8.decoder).join();
      final decoded = jsonDecode(body) as Map<String, dynamic>;
      final keys = decoded['keys'] as List<dynamic>? ?? const [];
      final map = <String, JWTKey>{};
      for (final raw in keys) {
        if (raw is! Map<String, dynamic>) continue;
        try {
          final key = JWTKey.fromJWK(raw);
          final kid = raw['kid'] as String?;
          if (kid != null && kid.isNotEmpty) {
            map[kid] = key;
          }
        } catch (_) {}
      }
      return map;
    } catch (error) {
      stderr.writeln('Falha ao buscar JWKS ($uri): $error');
      return {};
    } finally {
      client.close(force: true);
    }
  }

  String? userIdFromBearer(String? authorizationHeader) {
    if (authorizationHeader == null || authorizationHeader.isEmpty) {
      return null;
    }

    final parts = authorizationHeader.split(' ');
    if (parts.length != 2 || parts.first.toLowerCase() != 'bearer') {
      return null;
    }

    final token = parts[1].trim();
    if (token.isEmpty) return null;

    try {
      final header = JWT.decode(token).header;
      if (header == null) return null;
      final alg = header['alg']?.toString();
      final JWTKey key;
      switch (alg) {
        case 'HS256':
          key = SecretKey(_jwtSecret);
        case 'ES256':
          final kid = header['kid']?.toString();
          final ecKey = kid == null ? null : _jwksByKid[kid];
          if (ecKey == null) return null;
          key = ecKey;
        default:
          return null;
      }

      final jwt = JWT.verify(token, key);
      final sub = jwt.payload['sub'];
      if (sub is! String || sub.isEmpty) return null;
      return sub;
    } catch (_) {
      return null;
    }
  }
}
