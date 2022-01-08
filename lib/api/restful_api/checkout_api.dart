import '../../config/global.dart';
import '../helpers/http_manager.dart';

class CheckoutApi {
  static Future generateCheckoutData() async {
    try {
      final result = await httpManager.get(
        url: Globals.host + "rest/utility/generateCheckoutData",
      );
      return result;
    } catch (err) {
      print('generateCheckoutData catch err');
      print(err);
      return err;
    }
  }

  static setExistingAddress(form) async {
    try {
      return await httpManager.post(
        url: Globals.host + "rest/utility/address&existing=1",
        data: form,
      );
    } catch (err) {
      print(err);
      return err;
    }
  }

  static setNewAddress(form) async {
    try {
      return await httpManager.post(
        url: Globals.host + "rest/utility/address",
        data: form,
      );
    } catch (err) {
      print(err);
      return err;
    }
  }

  static setShippingMethod(form) async {
    try {
      return await httpManager.post(
        url: Globals.host + "rest/shipping_method/shippingmethods",
        data: form,
      );
    } catch (err) {
      print(err);
      return err;
    }
  }

  static setPaymentMethod(form) async {
    try {
      return await httpManager.post(
        url: Globals.host + "rest/payment_method/payments",
        data: form,
      );
    } catch (err) {
      print(err);
      return err;
    }
  }

  static orderConfirm(form) async {
    try {
      return await httpManager.post(
        url: Globals.host + "rest/confirm/confirm",
        data: form,
      );
    } catch (err) {
      print(err);
      return err;
    }
  }

  static forPaymentByUsingWebView() async {
    try {
      final result = await httpManager.get(
        url: Globals.host + "rest/confirm/confirm&page=pay",
      );
      return result;
    } catch (err) {
      print('forPaymentByUsingWebView catch err');
      print(err);
      return err;
    }
  }

  static finishOrder(form) async {
    try {
      return await httpManager.put(
        url: Globals.host + "rest/confirm/confirm",
        data: form,
      );
    } catch (err) {
      print(err);
      return err;
    }
  }

  static applyCoupon(form) async {
    try {
      return await httpManager.post(
        url: Globals.host + "rest/cart/coupon",
        data: form,
      );
    } catch (err) {
      print(err);
      return err;
    }
  }
}
