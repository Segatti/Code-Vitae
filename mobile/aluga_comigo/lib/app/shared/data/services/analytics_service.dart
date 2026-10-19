import 'dart:developer' as developer;

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

import '../../../../firebase_config.dart';

abstract interface class IAnalyticsService {
  Future<void> logEvent(
    String name, {
    Map<String, Object?> parameters = const {},
  });

  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  });

  Future<void> setUserId(String? userId);

  Future<void> setUserProperty({required String name, required String? value});
}

class AnalyticsService implements IAnalyticsService {
  FirebaseAnalytics? _analytics;

  bool get _enabled => FirebaseConfig.isConfigured && !kIsWeb;

  FirebaseAnalytics get _instance {
    _analytics ??= FirebaseAnalytics.instance;
    return _analytics!;
  }

  @override
  Future<void> logEvent(
    String name, {
    Map<String, Object?> parameters = const {},
  }) async {
    if (!_enabled) return;
    try {
      final sanitized = <String, Object>{};
      for (final entry in parameters.entries) {
        final value = entry.value;
        if (value == null) continue;
        if (value is String || value is num) {
          sanitized[entry.key] = value;
        } else {
          sanitized[entry.key] = value.toString();
        }
      }
      await _instance.logEvent(name: name, parameters: sanitized);
    } catch (error, stack) {
      developer.log(
        'Analytics logEvent failed: $error',
        name: 'AnalyticsService',
        stackTrace: stack,
      );
    }
  }

  @override
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    if (!_enabled) return;
    try {
      await _instance.logScreenView(
        screenName: screenName,
        screenClass: screenClass ?? screenName,
      );
    } catch (error, stack) {
      developer.log(
        'Analytics logScreenView failed: $error',
        name: 'AnalyticsService',
        stackTrace: stack,
      );
    }
  }

  @override
  Future<void> setUserId(String? userId) async {
    if (!_enabled) return;
    try {
      await _instance.setUserId(id: userId);
    } catch (error, stack) {
      developer.log(
        'Analytics setUserId failed: $error',
        name: 'AnalyticsService',
        stackTrace: stack,
      );
    }
  }

  @override
  Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    if (!_enabled) return;
    try {
      await _instance.setUserProperty(name: name, value: value);
    } catch (error, stack) {
      developer.log(
        'Analytics setUserProperty failed: $error',
        name: 'AnalyticsService',
        stackTrace: stack,
      );
    }
  }
}

class NoOpAnalyticsService implements IAnalyticsService {
  @override
  Future<void> logEvent(
    String name, {
    Map<String, Object?> parameters = const {},
  }) async {}

  @override
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {}

  @override
  Future<void> setUserId(String? userId) async {}

  @override
  Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {}
}
