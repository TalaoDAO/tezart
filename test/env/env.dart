import 'dart:io';

abstract class Env {
  static final Map<String, String> _env = _loadEnv();

  static String get tezosNodeUrl => _env['TEZOS_NODE_URL'] ?? 'http://localhost:20000';
  static String get originatorSk => _env['ORIGINATOR_SK'] ?? 'edskRpm2mUhvoUjHjXgMoDRxMKhtKfww1ixmWiHCWhHuMEEbGzdnz8Ks4vgarKDtxok7HmrEo1JzkXkdkvyw7Rtw6BNtSd7MJ7';
  static String get logLevel => _env['LOG_LEVEL'] ?? 'info';

  static Map<String, String> _loadEnv() {
    final map = <String, String>{};
    map.addAll(Platform.environment);

    final pathsToTry = [
      '.env.test',
      '.env.dist',
      'packages/tezart/.env.test',
      'packages/tezart/.env.dist',
    ];

    for (final path in pathsToTry) {
      final file = File(path);
      if (file.existsSync()) {
        try {
          final lines = file.readAsLinesSync();
          for (final line in lines) {
            final trimmed = line.trim();
            if (trimmed.isEmpty || trimmed.startsWith('#')) continue;
            final parts = trimmed.split('=');
            if (parts.length >= 2) {
              final key = parts[0].trim();
              final value = parts.sublist(1).join('=').trim();
              map[key] = value;
            }
          }
          break;
        } catch (_) {
          // Ignore reading errors and keep looking
        }
      }
    }
    return map;
  }
}
