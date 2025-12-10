import 'package:flutter/foundation.dart';

class AppLogger {
  static void log(String message, [String? tag]) {
    if (kDebugMode) {
      print('[${tag ?? 'APP'}] $message');
    }
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      print('[ERROR] $message');
      if (error != null) print('Error: $error');
      if (stackTrace != null) print('StackTrace: $stackTrace');
    }
  }
}