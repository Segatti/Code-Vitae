import 'package:postgres/postgres.dart';

class PostgresPool {
  PostgresPool(this._databaseUrl);

  final String _databaseUrl;
  Pool<dynamic>? _pool;

  Future<Pool<dynamic>> get client async {
    if (_pool != null) return _pool!;

    final uri = Uri.parse(_databaseUrl);
    final endpoint = Endpoint(
      host: uri.host,
      port: uri.port,
      database: uri.pathSegments.isEmpty ? 'postgres' : uri.pathSegments.first,
      username: uri.userInfo.split(':').first,
      password: uri.userInfo.contains(':')
          ? uri.userInfo.split(':').skip(1).join(':')
          : null,
    );

    _pool = Pool.withEndpoints(
      [endpoint],
      settings: PoolSettings(
        maxConnectionCount: 8,
        sslMode: SslMode.disable,
      ),
    );
    return _pool!;
  }

  Future<void> close() async {
    await _pool?.close();
    _pool = null;
  }
}
