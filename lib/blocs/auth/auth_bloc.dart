import 'dart:async';

import '../blocs.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../api/api.dart';
import '../../config/config.dart';
import '../../models/user.dart';

import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final CartBloc _cartBloc;
  final OrdersBloc _ordersBloc;
  AuthBloc(this._cartBloc, this._ordersBloc) : super(UnAuthenticated());

  final storage = FlutterSecureStorage();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is CheckAuth) {
      // try {
      //   print('check auth');
      //   yield SameScreenChecking();
      //   var sessionId = await storage.read(key: 'session');
      //   if (sessionId != null) {
      //     print('session exists');
      //     httpManager.baseOptions.headers["X-Oc-Session"] = sessionId;

      //     // validate token and get user data //
      //     final getProfile = await AuthApi.getProfile();
      //     print('getProfile');
      //     print(getProfile);
      //     if (getProfile['data'] != null) {
      //       var user = User.fromMap(getProfile['data']);

      //       Globals.user = user;

      //       yield Authenticated(user: user);
      //     } else {
      //       await storage.delete(key: 'token');
      //       yield UnAuthenticated();
      //     }
      //   } else {
      //     yield UnAuthenticated();
      //   }
      // } catch (err) {
      //   print(err);
      //   yield UnAuthenticated();
      // }
    }

    if (event is Login) {
      try {
        yield SameScreenChecking();
        var sessionId = await storage.read(key: 'session');

        final login = await AuthApi.login(event.form);
        if (login['data'] != null) {
          httpManager.baseOptions.headers["X-Oc-Session"] = sessionId;

          final user = User.fromMap(login['data']);
          Globals.user = user;

          yield Authenticated(user: user);
        } else {
          yield AuthFail(login['message']);
          yield UnAuthenticated();
        }
      } catch (err) {
        print(err);
        yield UnAuthenticated();
      }
    }

    if (event is SignUp) {
      try {
        yield SameScreenChecking();

        var sessionId = await storage.read(key: 'session');

        final signup = await AuthApi.signup(event.form);
        if (signup['data'] != null) {
          httpManager.baseOptions.headers["X-Oc-Session"] = sessionId;

          final user = User.fromMap(signup['data']);
          Globals.user = user;

          yield Authenticated(user: user);
        } else {
          yield AuthFail(signup['message']);
          yield UnAuthenticated();
        }
      } catch (err) {
        print(err);
        yield UnAuthenticated();
      }
    }

    if (event is GetSession) {
      try {
        print('event GetSession');
        final session = await AuthApi.getSessionId();
        if (session['data'] != null) {
          final sessionId = session['data']['session'];

          await storage.write(
            key: 'session',
            value: sessionId,
          );
          httpManager.baseOptions.headers["X-Oc-Session"] = sessionId;
        }
      } catch (err) {
        print(err);
      }
    }

    if (event is GetAccountInfo) {
      try {
        yield SameScreenChecking();
        var sessionId = await storage.read(key: 'session');
        if (sessionId != null) {
          httpManager.baseOptions.headers["X-Oc-Session"] = sessionId;

          // validate token and get user data //
          final getAccountInfo = await AuthApi.getAccountInfo();

          if (getAccountInfo['data'] != null) {
            var user = User.fromMap(getAccountInfo['data']);

            Globals.user = user;
            _cartBloc.add(LoadCart());
            _ordersBloc.add(GetOrders());
            yield Authenticated(user: user);
          } else {
            await storage.delete(key: 'token');
            yield UnAuthenticated();
          }
        } else {
          yield UnAuthenticated();
        }
      } catch (err) {
        print(err);
        yield UnAuthenticated();
      }
    }

    if (event is Logout) {
      try {
        final logout = await AuthApi.logout({});
        print(logout);
        if (logout['data'] != null) {
          await storage.delete(key: 'session');
          httpManager.baseOptions.headers["X-Oc-Session"] = null;
          final session = await AuthApi.getSessionId();
          if (session['data'] != null) {
            final sessionId = session['data']['session'];

            await storage.write(
              key: 'session',
              value: sessionId,
            );
            httpManager.baseOptions.headers["X-Oc-Session"] = sessionId;
          }
          yield UnAuthenticated();
        }
        yield UnAuthenticated();
      } catch (err) {
        print(err);
        yield UnAuthenticated();
      }
    }
  }
}
