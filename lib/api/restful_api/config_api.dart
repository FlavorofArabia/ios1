import '../../config/config.dart';

import '../helpers/http_manager.dart';

class ConfigApi {
  static Future<dynamic> productclasses() async {
    try {
      final result = await httpManager.get(
        url: Globals.host + 'feed/rest_api/productclasses',
      );
      return result;
    } catch (err) {
      print(err);
      return err;
    }
  }

  static Future<dynamic> languages() async {
    try {
      final result = await httpManager.get(
        url: Globals.host + 'feed/rest_api/languages',
      );
      return result;
    } catch (err) {
      return err;
    }
  }
}
