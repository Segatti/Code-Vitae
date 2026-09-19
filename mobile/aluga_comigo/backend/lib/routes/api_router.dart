import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../auth/jwt_validator.dart';
import '../db/user_rpc.dart';
import '../http/json_response.dart';

Handler buildApiRouter({
  required JwtValidator jwtValidator,
  required UserRpc userRpc,
}) {
  final router = Router();

  router.get('/health', (_) => jsonResponse(200, {'ok': true}));

  router.get('/v1/inventory', (request) async {
    final auth = _authenticate(request, jwtValidator);
    if (auth.response != null) return auth.response!;

    try {
      final inventory = await userRpc.getUserInventory(auth.userId!);
      return jsonResponse(200, inventory);
    } catch (error) {
      return jsonError(500, error.toString());
    }
  });

  router.post('/v1/inventory/consume-super-star', (request) async {
    final auth = _authenticate(request, jwtValidator);
    if (auth.response != null) return auth.response!;

    try {
      final ok = await userRpc.consumeSuperStar(auth.userId!);
      return jsonResponse(200, {'ok': ok});
    } catch (error) {
      return jsonError(500, error.toString());
    }
  });

  router.post('/v1/inventory/consume-super-chat', (request) async {
    final auth = _authenticate(request, jwtValidator);
    if (auth.response != null) return auth.response!;

    try {
      final ok = await userRpc.consumeSuperChat(auth.userId!);
      return jsonResponse(200, {'ok': ok});
    } catch (error) {
      return jsonError(500, error.toString());
    }
  });

  router.post('/v1/purchases/fulfill', (request) async {
    final auth = _authenticate(request, jwtValidator);
    if (auth.response != null) return auth.response!;

    final bodyResult = await _readJsonMap(request);
    if (bodyResult.response != null) return bodyResult.response!;
    final body = bodyResult.body!;

    final productId = body['productId'] as String?;
    final transactionId = body['transactionId'] as String?;
    final platform = body['platform'] as String? ?? 'google';

    if (productId == null ||
        productId.isEmpty ||
        transactionId == null ||
        transactionId.isEmpty) {
      return jsonError(400, 'productId e transactionId são obrigatórios');
    }

    try {
      final result = await userRpc.fulfillPurchase(
        userId: auth.userId!,
        productId: productId,
        transactionId: transactionId,
        platform: platform,
      );
      return jsonResponse(200, result);
    } catch (error) {
      return jsonError(500, error.toString());
    }
  });

  router.patch('/v1/account/active', (request) async {
    final auth = _authenticate(request, jwtValidator);
    if (auth.response != null) return auth.response!;

    final bodyResult = await _readJsonMap(request);
    if (bodyResult.response != null) return bodyResult.response!;
    final body = bodyResult.body!;

    final active = body['active'];
    if (active is! bool) {
      return jsonError(400, 'active (bool) é obrigatório');
    }

    try {
      await userRpc.setAccountActive(auth.userId!, active);
      return jsonResponse(200, {'ok': true});
    } catch (error) {
      return jsonError(500, error.toString());
    }
  });

  router.post('/v1/quests/progress', (request) async {
    final auth = _authenticate(request, jwtValidator);
    if (auth.response != null) return auth.response!;

    final bodyResult = await _readJsonMap(request);
    if (bodyResult.response != null) return bodyResult.response!;
    final body = bodyResult.body!;

    final actionType = body['actionType'] as String?;
    if (actionType == null || actionType.isEmpty) {
      return jsonError(400, 'actionType é obrigatório');
    }

    try {
      await userRpc.incrementQuestProgress(auth.userId!, actionType);
      return jsonResponse(200, {'ok': true});
    } catch (error) {
      return jsonError(500, error.toString());
    }
  });

  router.get('/v1/quests', (request) async {
    final auth = _authenticate(request, jwtValidator);
    if (auth.response != null) return auth.response!;

    try {
      final quests = await userRpc.getUserQuests(auth.userId!);
      return jsonResponse(200, {'items': quests});
    } catch (error) {
      return jsonError(500, error.toString());
    }
  });

  router.post('/v1/quests/<questId>/claim', (request, String questId) async {
    final auth = _authenticate(request, jwtValidator);
    if (auth.response != null) return auth.response!;

    if (questId.trim().isEmpty) {
      return jsonError(400, 'questId inválido');
    }

    try {
      final result = await userRpc.claimQuestReward(auth.userId!, questId);
      return jsonResponse(200, result);
    } catch (error) {
      return jsonError(500, error.toString());
    }
  });

  return router.call;
}

class _AuthResult {
  const _AuthResult({this.userId, this.response});

  final String? userId;
  final Response? response;
}

class _BodyResult {
  const _BodyResult({this.body, this.response});

  final Map<String, dynamic>? body;
  final Response? response;
}

_AuthResult _authenticate(Request request, JwtValidator jwtValidator) {
  final userId = jwtValidator.userIdFromBearer(request.headers['authorization']);
  if (userId == null) {
    return _AuthResult(response: jsonError(401, 'Não autenticado'));
  }
  return _AuthResult(userId: userId);
}

Future<_BodyResult> _readJsonMap(Request request) async {
  try {
    final raw = await request.readAsString();
    if (raw.trim().isEmpty) {
      return _BodyResult(response: jsonError(400, 'Corpo JSON vazio'));
    }
    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      return _BodyResult(response: jsonError(400, 'JSON inválido'));
    }
    return _BodyResult(body: decoded);
  } catch (_) {
    return _BodyResult(response: jsonError(400, 'JSON inválido'));
  }
}
