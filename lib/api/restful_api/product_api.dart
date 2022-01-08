import '../../config/global.dart';

import '../helpers/http_manager.dart';

class ProductApi {
  static Future getHomePageCategoryWithItProducts() async {
    try {
      final result = await httpManager.get(
        url: Globals.host + "feed/rest_api/getHomePageCategoryWithItProducts",
      );
      return result;
    } catch (err) {
      print(err);
      return err;
    }
  }

  static Future product(productId) async {
    try {
      final result = await httpManager.get(
        url: Globals.host + "feed/rest_api/products&id=$productId",
      );
      return result;
    } catch (err) {
      print(err);
      return err;
    }
  }

  static Future search(query) async {
    try {
      final result = await httpManager.get(
        url: Globals.host +
            "feed/rest_api/products&search=$query&limit=1&page=1",
      );
      return result;
    } catch (err) {
      print(err);
      return err;
    }
  }

  static productLivePrice(productId, form) async {
    try {
      final result = await httpManager.post(
        url: Globals.host + "feed/rest_api/price&product_id=$productId",
        data: form,
      );
      return result;
    } catch (err) {
      print(err);
      return err;
    }
  }
}
