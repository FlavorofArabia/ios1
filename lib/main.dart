import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';

import './screens/main_navigation/main_navigation.dart';
import './blocs/blocs.dart';
import './config/config.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Color(0xff2858CF),
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  try {
    WidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();
    runApp(
      EasyLocalization(
        supportedLocales: [Locale('en'), Locale('ar')],
        path: 'assets/locale', // <-- change the path of the translation files
        fallbackLocale: Locale('ar'),
        child: MyApp(),
      ),
    );
  } catch (err) {
    print(err);

    runApp(MyApp());
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final Routes route = Routes();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    final isBackground = state == AppLifecycleState.paused;

    print(state);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CurrencyBloc>(
          create: (context) => CurrencyBloc()
            ..add(LoadCurrencies())
            ..add(
              GetCurrency(),
            ),
        ),
        BlocProvider<LanguageBloc>(
          create: (context) => LanguageBloc()
            ..add(LoadLanguages())
            ..add(
              GetLanguage(),
            ),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(CartBloc(), OrdersBloc())
            ..add(
              GetAccountInfo(),
            )
            ..add(GetSession()),
        ),
        BlocProvider<SlidersBloc>(
          create: (context) => SlidersBloc()..add(GetSliders()),
        ),
        BlocProvider<CategoriesBloc>(create: (context) => CategoriesBloc()
            // ..add(GetCategories()),
            ),
        BlocProvider<OrdersBloc>(create: (context) => OrdersBloc()
            // ..add(GetOrders()),
            ),
        BlocProvider<ProductsBloc>(create: (context) => ProductsBloc()
            // ..add(GetProducts()),
            ),
        BlocProvider<CartBloc>(create: (context) => CartBloc()
            // ..add(LoadCart()),
            ),
      ],
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          return BlocConsumer<CurrencyBloc, CurrencyState>(
            listener: (context, currencyState) {
              if (currencyState is CurrencyUpdated) {
                BlocProvider.of<ProductsBloc>(context).add(GetProducts());
                BlocProvider.of<CategoriesBloc>(context).add(GetCategories());
                if (authState is Authenticated) {
                  BlocProvider.of<CartBloc>(context).add(LoadCart());
                  BlocProvider.of<OrdersBloc>(context).add(GetOrders());
                }
              }
            },
            builder: (context, currencyState) {
              return BlocConsumer<LanguageBloc, LanguageState>(
                listener: (context, languageState) {
                  if (languageState is LanguageUpdated) {
                    BlocProvider.of<ProductsBloc>(context).add(GetProducts());
                    BlocProvider.of<CategoriesBloc>(context)
                        .add(GetCategories());
                    if (authState is Authenticated) {
                      BlocProvider.of<CartBloc>(context).add(LoadCart());
                      BlocProvider.of<OrdersBloc>(context).add(GetOrders());
                    }
                  }
                },
                builder: (context, languageState) {
                  return MaterialApp(
                    title: 'Flavor',
                    debugShowCheckedModeBanner: false,
                    theme: ThemeData(
                      appBarTheme: AppBarTheme(
                        iconTheme: IconThemeData(color: Colors.white),
                        titleTextStyle: TextStyle(color: Colors.white),
                        centerTitle: true,
                      ),
                      scaffoldBackgroundColor: Color(0xffF9FAFF),
                      primaryColor: Color(0xff2858CF),
                      textTheme: TextTheme(
                        bodyText1: TextStyle(
                          fontFamily: languageState is LanguageUpdated &&
                                  languageState.locale.languageCode
                                      .contains('ar')
                              ? 'GE'
                              : null,
                        ),
                        bodyText2: TextStyle(
                          fontFamily: languageState is LanguageUpdated &&
                                  languageState.locale.languageCode
                                      .contains('ar')
                              ? 'GE'
                              : null,
                        ),
                      ),
                    ),
                    localizationsDelegates: context.localizationDelegates,
                    supportedLocales: context.supportedLocales,
                    locale: context.locale,
                    home: MainNavigation(),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
