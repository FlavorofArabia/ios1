import '../../config/config.dart';

import '../helpers/http_manager.dart';

class SlidersApi {
  static Future<dynamic> getAll() async {
    final result = await httpManager.get(url: Globals.host + 'feed/rest_api/banners&key=slider');
    return result;
  }
}
