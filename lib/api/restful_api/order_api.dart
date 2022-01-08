import '../../config/global.dart';
import '../helpers/http_manager.dart';

class OrderApi {
  static Future getOrders() async {
    try {
      final result = await httpManager.get(
        url: Globals.host + "rest/order/orders",
      );
      print('result is ...');
      print(result);
      return result;
    } catch (err) {
      print('getOrder catch err');
      print(err);
      return err;
    }
  }

  static getOrder(orderId) async {
    try {
      final result = await httpManager.get(
        url: Globals.host + "rest/order/orders&id=$orderId",
      );
      return result;
    } catch (err) {
      print('getOrder catch err');
      print(err);
      return err;
    }
  }
}
