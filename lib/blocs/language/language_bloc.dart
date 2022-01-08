import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flavor/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/config.dart';
import '../../api/helpers/http_manager.dart';
import '../../api/restful_api/config_api.dart';
import '../../models/config.dart';

part 'language_event.dart';
part 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(LanguageInitial());

  @override
  Stream<LanguageState> mapEventToState(
    LanguageEvent event,
  ) async* {
    if (event is ChangeLanguage) {
      yield LanguageUpdating();
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // AppLanguage.defaultLanguage = event.locale;

      ///Preference save
      prefs.setString(
        Globals.prefLanguage,
        event.locale.languageCode,
      );

      Globals.oldLang = event.locale.languageCode;
      httpManager.baseOptions.headers["X-Oc-Merchant-Language"] =
          event.locale.languageCode;

      yield LanguageUpdated(event.locale);
    }

    if (event is GetLanguage) {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        // Setup Language //
        final oldLanguage = prefs.getString(Globals.prefLanguage) ?? '';
        Globals.oldLang = oldLanguage;
        Globals.selectedLanguage = oldLanguage;
        // AppLanguage.defaultLanguage = Locale(oldLanguage);
        if (oldLanguage != '') {
          httpManager.baseOptions.headers["X-Oc-Merchant-Language"] =
              oldLanguage;
          yield LanguageUpdated(Locale(oldLanguage));
        }
      } catch (err) {
        print(err);
      }
    }

    if (event is LoadLanguages) {
      try {
        final result = await ConfigApi.languages();
        if (result['data'] != null) {
          Globals.allLanguages = [];
          for (var i = 0; i < result['data'].length; i++) {
            Globals.allLanguages.add(Language.fromMap(result['data'][i]));
          }
          yield LanguageUpdated(Locale(Globals.oldLang));
        }
      } catch (err) {
        print(err);
      }
    }
  }
}
