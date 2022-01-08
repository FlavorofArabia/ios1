import 'dart:ui';

import 'package:flavor/models/config.dart';

import '../blocs/auth/auth_bloc.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/orders/orders_bloc.dart';
import '../components/primary_button.dart';
import '../components/secodary_button.dart';
import './images.dart';
import '../screens/account/auth.dart';
import '../screens/main_navigation/main_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/user.dart';

class Globals {
  // Variables used in app
  static bool debug = true;
  static User user = User();
  // static String host = 'http://192.168.93.1:3000';

  static String host = 'https://flavorofarabia.com/index.php?route=';
  static String selectedCurrency = '';
  static List<Language> allLanguages = [];
  static List<Currency> allCurrencies = [];
  static String selectedLanguage = '';

  static String oldLang = '';
  static String oldCurrency = '';

  static Color primaryColor = Color(0xff0c425d);

  static List<BoxShadow> shadow = [
    BoxShadow(
      color: primaryColor,
      offset: new Offset(0.0, 0.0),
      blurRadius: 2.0,
      spreadRadius: 0.5,
    )
  ];

  // Shared Preference Variables //
  static String prefLanguage = 'language';
  static String prefCurrency = 'currency';
  static String prefTheme = 'theme';
  static String prefFont = 'font';
  static String prefDarkOption = 'darkOption';

  static auth(context) {
    return showBottomSheet(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.75,
            maxChildSize: 0.8,
            minChildSize: 0.75,
            builder: (
              BuildContext context,
              ScrollController scrollController,
            ) {
              return Directionality(
                textDirection: TextDirection.rtl,
                child: BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is Authenticated) {
                      BlocProvider.of<CartBloc>(context).add(LoadCart());
                      BlocProvider.of<OrdersBloc>(context).add(GetOrders());
                      // BlocProvider.of<AuthBloc>(context).add(GetAccountInfo());
                      return Navigator.pop(context);
                    }
                  },
                  builder: (context, state) {
                    return AuthScreen();
                  },
                ),
              );
            },
          ),
        );
      },
    );
    // showModalBottomSheet(
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(100.0),
    //   ),
    //   context: context,
    //   builder: (context) {
    //     return Container(
    //         height: MediaQuery.of(context).size.height * 0.8,
    //         child:BackdropFilter(
    //       filter: ImageFilter.blur(
    //           sigmaX: 1, sigmaY: 1, tileMode: TileMode.clamp),
    //       child:  Directionality(
    //           textDirection: TextDirection.rtl,
    //           child: AuthScreen(),
    //         ),
    //       ),
    //     );
    //   },
    // );
  }

  static addToCart(context) {
    return showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                    child: Image.asset(
                      Images.AddedToCart,
                      width: 120,
                      height: 120,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Text(
                    'تمت الاضافة الي السلة',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'هل ترغب في مواصلة التسوق أو فتح السلة؟',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        new BoxShadow(
                          color: Colors.black12,
                          offset: new Offset(0.0, 0.0),
                          blurRadius: 2.0,
                          spreadRadius: 1.0,
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: SecondaryButton(
                            title: 'مواصلة التسوق',
                            horizontalPadding: 8,
                            verticalPadding: 4,
                            onTap: () => Navigator.pop(context),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: PrimaryButton(
                            title: 'عرض السلة',
                            padding: 8,
                            onTap: () {
                              Navigator.popUntil(
                                context,
                                (route) => route.isFirst,
                              );
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder: (_, __, ___) => Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: MainNavigation(tabIndex: 2),
                                  ),
                                  transitionDuration:
                                      Duration(milliseconds: 500),
                                  transitionsBuilder: (_,
                                      Animation<double> animation,
                                      __,
                                      Widget child) {
                                    return Opacity(
                                      opacity: animation.value,
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // singlton
  static final Globals _instance = Globals.internal();

  factory Globals() => _instance;

  Globals.internal();
}
