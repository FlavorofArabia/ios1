import '../../config/config.dart';

import '../helpers/http_manager.dart';

class CategoryApi {
  static Future<Map<String, dynamic>> categoriesOneLevel() async {
    final result = await httpManager.get(
      url: Globals.host + 'feed/rest_api/categories',
    );
    return result;
  }

  static productsCategory(categoryId) async {
    final result = await httpManager.get(
      url: Globals.host + 'feed/rest_api/products&category=$categoryId&page=1',
    );
    return result;
  }

  static filter(categoryId, filterId) async {
    final result = await httpManager.get(
      url: Globals.host +
          // 'feed/rest_api/products&category=104&page=1&filters=$filterId',
          'feed/rest_api/products&category=$categoryId&page=1&filters=$filterId',
    );
    // print('result is ...');
    // print(categoryId);
    // print(filterId);
    // print(result);
    return result;
  }
}
