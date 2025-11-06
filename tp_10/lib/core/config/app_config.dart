import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Centralises access to environment-aware configuration values.
class AppConfig {
  AppConfig._();

  /// Returns the todos endpoint based on the active platform.
  static String get todosEndpoint {
    final androidUrl = dotenv.env['ANDROID_URL_TODOS'];
    final iosUrl = dotenv.env['IOS_URL_TODOS'];

    if (androidUrl == null || iosUrl == null) {
      throw StateError('Missing todos endpoint configuration in .env file.');
    }

    if (!kIsWeb && Platform.isIOS) {
      return iosUrl;
    }

    return androidUrl;
  }
}
