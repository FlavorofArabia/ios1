import '../../config/config.dart';

import '../helpers/http_manager.dart';

class AuthApi {
  static Future<dynamic> signup(form) async {
    try {
      final result = await httpManager.post(
        url: Globals.host + 'rest/register/register',
        data: form,
      );
      return result;
    } catch (err) {
      print(err);
      return err;
    }
  }

  static Future<dynamic> login(form) async {
    try {
      final result = await httpManager.post(
        url: Globals.host + 'rest/login/login',
        data: form,
      );
      return result;
    } catch (err) {
      return err;
    }
  }

  static Future<dynamic> getSessionId() async {
    try {
      final result = await httpManager.get(
        url: Globals.host + 'feed/rest_api/session',
      );
      return result;
    } catch (err) {
      print(err);
      return err;
    }
  }

  static Future<dynamic> getAccountInfo() async {
    try {
      // await Future.delayed(Duration(seconds: 2));
      // return DummyData.profile;
      final result = await httpManager.get(
        url: Globals.host + 'rest/account/account',
      );
      return result;
    } catch (err) {
      print(err);
      return err;
    }
  }

  static Future<dynamic> logout(form) async {
    try {
      final result = await httpManager.post(
        url: Globals.host + 'rest/logout/logout',
        data: form,
      );
      return result;
    } catch (err) {
      return err;
    }
  }

  static Future<dynamic> getAddresses() async {
    try {
      final result = await httpManager.get(
        url: Globals.host + 'rest/account/address',
      );
      return result;
    } catch (err) {
      print(err);
      return err;
    }
  }

  static Future<dynamic> addAddress(form) async {
    try {
      final result = await httpManager.post(
        url: Globals.host + 'rest/account/address',
        data: form,
      );
      return result;
    } catch (err) {
      return err;
    }
  }

  static Future<dynamic> deleteAddress(addressId) async {
    try {
      final result = await httpManager.delete(
        url: Globals.host + 'rest/account/address&id=$addressId',
        // data: {},
      );
      return result;
    } catch (err) {
      return err;
    }
  }

  static Future<dynamic> countries() async {
    try {
      final result = await httpManager.get(
        url: Globals.host + 'feed/rest_api/countries',
      );
      return result;
    } catch (err) {
      print(err);
      return err;
    }
  }

  static Future<dynamic> cities(countryId) async {
    try {
      final result = await httpManager.get(
        url: Globals.host + 'feed/rest_api/countries&id=$countryId',
      );
      return result;
    } catch (err) {
      print(err);
      return err;
    }
  }
}
