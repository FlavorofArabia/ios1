import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/config.dart';
import '../../api/helpers/http_manager.dart';
import '../../api/restful_api/config_api.dart';
import '../../models/config.dart';

part 'currencies_event.dart';
part 'currencies_state.dart';

class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  CurrencyBloc() : super(CurrencyInitial());

  @override
  Stream<CurrencyState> mapEventToState(
    CurrencyEvent event,
  ) async* {
    if (event is ChangeCurrency) {
      yield CurrencyUpdating();
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // AppCurrency.defaultCurrency = event.locale;

      ///Preference save
      prefs.setString(
        Globals.prefCurrency,
        event.currency,
      );

      Globals.oldCurrency = event.currency;
      httpManager.baseOptions.headers["X-Oc-Currency"] = event.currency;

      yield CurrencyUpdated(event.currency);
    }

    if (event is GetCurrency) {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        // Setup Currency //
        final oldCurrency = prefs.getString(Globals.prefCurrency) ?? '';
        Globals.oldCurrency = oldCurrency;
        Globals.selectedCurrency = oldCurrency;
        if (oldCurrency != '') {
          httpManager.baseOptions.headers["X-Oc-Currency"] = oldCurrency;
          yield CurrencyUpdated(oldCurrency);
        }
      } catch (err) {
        print(err);
      }
    }

    if (event is LoadCurrencies) {
      try {
        final result = await ConfigApi.productclasses();
        if (result['data'] != null) {
          if (result['data']['currencies'] != null) {
            Globals.allCurrencies = [];
            for (var i = 0; i < result['data']['currencies'].length; i++) {
              Globals.allCurrencies.add(
                Currency.fromMap(result['data']['currencies'][i]),
              );
            }
          }
        }
      } catch (err) {
        print(err);
      }
    }
  }
}
