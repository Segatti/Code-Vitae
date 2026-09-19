import 'dart:io';

import 'package:flutter/foundation.dart';

class BackendConfig {
  static const _fromEnvironment = String.fromEnvironment('BACKEND_API_URL');

  static String get baseUrl {
    final raw = _fromEnvironment.isNotEmpty
        ? _fromEnvironment
        : 'http://127.0.0.1:8080';
    return _hostForPlatform(raw);
  }

  static String _hostForPlatform(String url) {
    if (kIsWeb || !Platform.isAndroid) return url;
    return url
        .replaceFirst('127.0.0.1', '10.0.2.2')
        .replaceFirst('localhost', '10.0.2.2');
  }

  static bool get isConfigured => baseUrl.trim().isNotEmpty;
}
