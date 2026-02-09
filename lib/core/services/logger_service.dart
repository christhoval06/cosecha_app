import 'dart:developer' as developer;

enum LogLevel { debug, info, warning, error }

class LoggerService {
  LoggerService._();

  static void debug(String message, {String tag = 'DEBUG', Object? data}) {
    _log(level: LogLevel.debug, tag: tag, message: message, data: data);
  }

  static void info(String message, {String tag = 'INFO', Object? data}) {
    _log(level: LogLevel.info, tag: tag, message: message, data: data);
  }

  static void warning(String message, {String tag = 'WARNING', Object? data}) {
    _log(level: LogLevel.warning, tag: tag, message: message, data: data);
  }

  static void error(
    String message, {
    String tag = 'ERROR',
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      message,
      name: tag,
      error: error,
      stackTrace: stackTrace,
      level: 1000,
    );
  }

  static void _log({
    required LogLevel level,
    required String tag,
    required String message,
    Object? data,
  }) {
    developer.log(
      _formatMessage(message, data),
      name: tag,
      level: _mapLevel(level),
    );
  }

  static String _formatMessage(String message, Object? data) {
    if (data == null) return message;
    return '$message | data: $data';
  }

  static int _mapLevel(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return 500;
      case LogLevel.info:
        return 800;
      case LogLevel.warning:
        return 900;
      case LogLevel.error:
        return 1000;
    }
  }
}
