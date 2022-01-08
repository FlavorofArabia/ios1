import '../../config/global.dart';
import '../helpers/http_manager.dart';

class CartApi {
  static Future getCart() async {
    try {
      final result = await httpManager.get(
        url: Globals.host + "rest/cart/cart",
      );

      return result;
    } catch (err) {
      print('getCart catch err');
      print(err);
      return err;
    }
  }

  static addItem(form) async {
    try {
      return await httpManager.post(
        url: Globals.host + "rest/cart/cart",
        data: form,
      );
    } catch (err) {
      print(err);
      return err;
    }
  }

  static updateItemInCart(form) async {
    try {
      return await httpManager.put(
        url: Globals.host + "rest/cart/cart",
        data: form,
      );
    } catch (err) {
      print(err);
      return err;
    }
  }

  static deleteItem(form) async {
    try {
      return await httpManager.delete(
        url: Globals.host + "rest/cart/cart",
        data: form,
      );
    } catch (err) {
      print(err);
      return err;
    }
  }
}
