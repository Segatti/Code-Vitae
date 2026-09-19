import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:material_ui/material_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../backend_config.dart';
import '../../domain/entities/failures.dart';
import '../../domain/errors/supabase_error_handler.dart';
import '../../domain/typedefs/returns.dart';

class AlugaComigoApiClient {
  AlugaComigoApiClient({
    required SupabaseClient supabase,
    http.Client? httpClient,
    String? baseUrl,
  }) : _supabase = supabase,
       _http = httpClient ?? http.Client(),
       _baseUrl = (baseUrl ?? BackendConfig.baseUrl).replaceAll(
         RegExp(r'/+$'),
         '',
       );

  final SupabaseClient? _supabase;
  final http.Client _http;
  final String _baseUrl;

  Future<bool> checkHealth() async {
    try {
      final uri = Uri.parse('$_baseUrl/health');
      final response = await _http
          .get(uri)
          .timeout(const Duration(seconds: 15));
      if (response.statusCode != 200) return false;
      final decoded = jsonDecode(response.body);
      return decoded is Map && decoded['ok'] == true;
    } catch (_) {
      return false;
    }
  }

  Future<Json> getUserInventory() async {
    final decoded = await _request('GET', '/v1/inventory');
    return Map<String, dynamic>.from(decoded as Map);
  }

  Future<bool> consumeSuperStar() async {
    final decoded = await _request('POST', '/v1/inventory/consume-super-star');
    final map = Map<String, dynamic>.from(decoded as Map);
    return map['ok'] == true;
  }

  Future<bool> consumeSuperChat() async {
    final decoded = await _request('POST', '/v1/inventory/consume-super-chat');
    final map = Map<String, dynamic>.from(decoded as Map);
    return map['ok'] == true;
  }

  Future<void> fulfillPurchase({
    required String productId,
    required String transactionId,
    required String platform,
  }) async {
    await _request(
      'POST',
      '/v1/purchases/fulfill',
      body: {
        'productId': productId,
        'transactionId': transactionId,
        'platform': platform,
      },
    );
  }

  Future<void> setAccountActive(bool active) async {
    await _request('PATCH', '/v1/account/active', body: {'active': active});
  }

  Future<void> incrementQuestProgress(String actionType) async {
    try {
      await _request(
        'POST',
        '/v1/quests/progress',
        body: {'actionType': actionType},
      );
    } catch (error) {
      debugPrint('incrementQuestProgress: $error');
    }
  }

  Future<List<Json>> getUserQuests() async {
    final decoded = await _request('GET', '/v1/quests');
    final map = Map<String, dynamic>.from(decoded as Map);
    final list = map['items'] as List<dynamic>? ?? const [];
    return list.map((item) => Map<String, dynamic>.from(item as Map)).toList();
  }

  Future<void> claimQuestReward(String questId) async {
    await _request('POST', '/v1/quests/$questId/claim');
  }

  Future<Object?> _request(
    String method,
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final token = _supabase?.auth.currentSession?.accessToken;
    if (token == null || token.isEmpty) {
      throw FailureDatasource(
        message: 'Sessão expirada. Faça login novamente.',
      );
    }

    final uri = Uri.parse('$_baseUrl$path');
    final headers = {
      'authorization': 'Bearer $token',
      'content-type': 'application/json',
    };

    late http.Response response;
    switch (method) {
      case 'GET':
        response = await _http.get(uri, headers: headers);
      case 'POST':
        response = await _http.post(
          uri,
          headers: headers,
          body: body == null ? null : jsonEncode(body),
        );
      case 'PATCH':
        response = await _http.patch(
          uri,
          headers: headers,
          body: body == null ? null : jsonEncode(body),
        );
      default:
        throw StateError('HTTP method não suportado: $method');
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    }

    String message = response.body;
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map && decoded['error'] is String) {
        message = decoded['error'] as String;
      }
    } catch (_) {}

    throw FailureDatasource(
      message: SupabaseErrorHandler.getMessage(
        response.statusCode.toString(),
        message,
      ),
    );
  }
}
