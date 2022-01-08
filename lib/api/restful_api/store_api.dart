import '../../config/config.dart';

import '../helpers/http_manager.dart';

class StoreApi {
  static Future<dynamic> getAll() async {
    final result = await httpManager.get(url: Globals.host + '/store');
    return result;
  }

  static Future<dynamic> getOne(storeId) async {
    final result = await httpManager.get(url: Globals.host + '/store/$storeId');
    return result;
  }

  static Future<dynamic> addOne(form) async {
    final result = await httpManager.post(
      url: Globals.host + '/store/app',
      data: form,
    );
    return result;
  }
}
