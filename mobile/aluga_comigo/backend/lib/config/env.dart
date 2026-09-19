import 'dart:io';

class Env {
  Env._({
    required this.port,
    required this.databaseUrl,
    required this.jwtSecret,
    required this.supabaseUrl,
  });

  final int port;
  final String databaseUrl;
  final String jwtSecret;
  final String supabaseUrl;

  static final Map<String, String> _fileEnv = {};

  static Env load() {
    _loadDotEnvFile();

    final port =
        int.tryParse(_env('PORT') ?? '8080') ?? 8080;
    final databaseUrl = _env('DATABASE_URL') ??
        'postgresql://postgres:postgres@127.0.0.1:54322/postgres';
    final jwtSecret = _env('SUPABASE_JWT_SECRET') ??
        'super-secret-jwt-token-with-at-least-32-characters-long';
    final supabaseUrl = (_env('SUPABASE_URL') ?? 'http://127.0.0.1:54321')
        .replaceAll(RegExp(r'/+$'), '');

    if (jwtSecret.length < 16) {
      stderr.writeln('SUPABASE_JWT_SECRET ausente ou muito curto.');
      exit(1);
    }

    return Env._(
      port: port,
      databaseUrl: databaseUrl,
      jwtSecret: jwtSecret,
      supabaseUrl: supabaseUrl,
    );
  }

  static String? _env(String key) =>
      Platform.environment[key] ?? _fileEnv[key];

  static void _loadDotEnvFile() {
    _fileEnv.clear();
    final file = File('.env');
    if (!file.existsSync()) return;

    for (final line in file.readAsLinesSync()) {
      final trimmed = line.trim();
      if (trimmed.isEmpty || trimmed.startsWith('#')) continue;
      final eq = trimmed.indexOf('=');
      if (eq <= 0) continue;
      final key = trimmed.substring(0, eq).trim();
      var value = trimmed.substring(eq + 1).trim();
      if (value.startsWith('"') && value.endsWith('"') && value.length >= 2) {
        value = value.substring(1, value.length - 1);
      }
      _fileEnv[key] = value;
    }
  }
}
