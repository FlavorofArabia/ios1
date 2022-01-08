import '../../config/config.dart';

import '../helpers/http_manager.dart';

class UserApi {
  static Future<dynamic> settings() async {
    final result = await httpManager.get(
      url: Globals.host + 'feed/rest_api/stores&id=0',
    );
    return result;
  }

  static Future<dynamic> pages() async {
    final result = await httpManager.get(
      url: Globals.host + 'feed/rest_api/information',
    );
    return result;
  }

  static Future<dynamic> page(pageId) async {
    final result = await httpManager.get(
      url: Globals.host + 'feed/rest_api/information&id=$pageId',
    );
    return result;
  }
}
