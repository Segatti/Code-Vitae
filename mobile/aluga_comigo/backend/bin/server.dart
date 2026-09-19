import 'dart:io';

import 'package:aluga_comigo_backend/auth/jwt_validator.dart';
import 'package:aluga_comigo_backend/config/env.dart';
import 'package:aluga_comigo_backend/db/postgres_pool.dart';
import 'package:aluga_comigo_backend/db/user_rpc.dart';
import 'package:aluga_comigo_backend/routes/api_router.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

Future<void> main() async {
  final env = Env.load();
  final pool = PostgresPool(env.databaseUrl);
  final jwtValidator = await JwtValidator.create(
    jwtSecret: env.jwtSecret,
    supabaseUrl: env.supabaseUrl,
  );
  final userRpc = UserRpc(pool);

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(buildApiRouter(
        jwtValidator: jwtValidator,
        userRpc: userRpc,
      ));

  final server = await shelf_io.serve(
    handler,
    InternetAddress.anyIPv4,
    env.port,
  );

  stdout.writeln(
    'Aluga Comigo backend ouvindo em http://${server.address.host}:${server.port}',
  );

  await ProcessSignal.sigint.watch().first;
  await pool.close();
  await server.close();
}
