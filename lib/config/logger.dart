import 'dart:developer' as developer;
import '../config/config.dart';

class UtilLogger {
  static const String TAG = "Mohamed";

  static log([String tag = TAG, dynamic msg]) {
    if (Globals.debug) {
      developer.log('$msg', name: tag);
    }
  }

  ///Singleton factory
  static final UtilLogger _instance = UtilLogger._internal();

  factory UtilLogger() {
    return _instance;
  }

  UtilLogger._internal();
}
