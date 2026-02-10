import 'package:flutter/material.dart';

class AppNavigator {
  AppNavigator._();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static String? _pendingRoute;
  static Object? _pendingArguments;

  static void pushNamed(String route, {Object? arguments}) {
    final state = navigatorKey.currentState;
    if (state == null) {
      _pendingRoute = route;
      _pendingArguments = arguments;
      return;
    }

    state.pushNamed(route, arguments: arguments);
  }

  static void flushPendingRoute() {
    final route = _pendingRoute;
    if (route == null) return;

    final state = navigatorKey.currentState;
    if (state == null) return;

    state.pushNamed(route, arguments: _pendingArguments);
    _pendingRoute = null;
    _pendingArguments = null;
  }
}
