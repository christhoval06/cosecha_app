import 'package:flutter/material.dart';

class AppNavigator {
  AppNavigator._();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static String? _pendingRoute;
  static Object? _pendingArguments;

  static void pushNamed(String route, {Object? arguments}) {
    final state = navigatorKey.currentState;
    if (!_canNavigate(state)) {
      _pendingRoute = route;
      _pendingArguments = arguments;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        flushPendingRoute();
      });
      return;
    }

    try {
      state!.pushNamed(route, arguments: arguments);
    } catch (_) {
      _pendingRoute = route;
      _pendingArguments = arguments;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        flushPendingRoute();
      });
    }
  }

  static void flushPendingRoute() {
    final route = _pendingRoute;
    if (route == null) return;

    final state = navigatorKey.currentState;
    if (!_canNavigate(state)) return;

    try {
      state!.pushNamed(route, arguments: _pendingArguments);
    } catch (_) {
      return;
    }
    _pendingRoute = null;
    _pendingArguments = null;
  }

  static bool _canNavigate(NavigatorState? state) {
    if (state == null) return false;
    final context = state.context;
    return state.mounted && context.mounted;
  }
}
