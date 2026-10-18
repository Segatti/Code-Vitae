import 'package:flutter/widgets.dart';

typedef AppResumeCallback = void Function();

/// Estado de foreground e callbacks de retorno ao app (realtime + refresh).
abstract final class AppLifecycleBridge {
  static AppLifecycleState lifecycleState = AppLifecycleState.resumed;

  static final List<AppResumeCallback> _resumeCallbacks = [];

  static bool get isForeground =>
      lifecycleState == AppLifecycleState.resumed;

  static void updateLifecycle(AppLifecycleState state) {
    lifecycleState = state;
    if (state == AppLifecycleState.resumed) {
      for (final callback in List<AppResumeCallback>.from(_resumeCallbacks)) {
        callback();
      }
    }
  }

  static void addResumeListener(AppResumeCallback callback) {
    if (!_resumeCallbacks.contains(callback)) {
      _resumeCallbacks.add(callback);
    }
  }

  static void removeResumeListener(AppResumeCallback callback) {
    _resumeCallbacks.remove(callback);
  }
}
