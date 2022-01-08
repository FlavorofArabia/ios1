import 'package:easy_localization/easy_localization.dart';
import 'dart:ui';

import 'package:url_launcher/url_launcher.dart';

import '../../blocs/blocs.dart';
import '../../api/api.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../components/secodary_button.dart';
import '../../config/config.dart';
import '../../screens/account/page_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  void initState() {
    getData();
    getContact();
    super.initState();
  }

  List pages = [];

  bool _isLoading = false;
  getData() async {
    try {
      pages = [];
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }

      // final res = await UserApi.settings();
      final res = await UserApi.pages();

      if (res['data'] != null && res['data'] is Iterable) {
        for (var i = 0; i < res['data'].length; i++) {
          pages.add(res['data'][i]);
        }
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (err) {
      print(err);
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  dynamic settings;
  bool _loadingSettings = false;
  getContact() async {
    try {
      pages = [];
      if (mounted) {
        setState(() {
          _loadingSettings = true;
        });
      }

      final res = await UserApi.settings();
      if (res['data'] != null) {
        settings = res['data'];
      }

      if (mounted) {
        setState(() {
          _loadingSettings = false;
        });
      }
    } catch (err) {
      print(err);
      if (mounted) {
        setState(() {
          _loadingSettings = false;
        });
      }
    }
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _item({String? image, String? text, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  image != null
                      ? Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xffBFBFBF),
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Image.asset(
                                image,
                                width: 15,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 10),
                          ],
                        )
                      : Container(),
                  Text(
                    text ?? '',
                    style: TextStyle(
                      color: Color(0xffBFBFBF),
                    ),
                  ),
                ],
              ),
            ),
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(3),
              child: Icon(
                Icons.arrow_back_ios_sharp,
                color: Color(0xffBFBFBF),
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String selectedCurrency = Globals.selectedCurrency;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9FAFF),
      appBar: AppBar(
        title: Text(
          tr('account'),
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'GE',
          ),
        ),
        flexibleSpace: Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.centerLeft,
          child: Image(
            image: AssetImage(Images.AppBar),
            fit: BoxFit.contain,
          ),
        ),
      ),
      body:
          // BlocBuilder<AuthBloc, AuthState>(
          //   builder: (context, authState) {
          //     if (authState is Authenticated) {
          //       return
          Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ListView(
          children: [
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is Authenticated) {
                  return Container();
                }
                return Column(
                  children: [
                    SizedBox(height: 25),
                    GestureDetector(
                      onTap: () {
                        Globals.auth(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    child: Icon(
                                      Icons.account_box_rounded,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'انشاء حساب - تسجيل دخول',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Transform(
                              transform: Matrix4.rotationY(3),
                              child: Icon(
                                Icons.arrow_back_ios_sharp,
                                color: Theme.of(context).primaryColor,
                                size: 16,
                              ),
                            ),
                            SizedBox(width: 10),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 15),
            _loadingSettings
                ? Center(child: CircularProgressIndicator())
                : settings == null
                    ? SecondaryButton(
                        title: 'التواصل',
                        onTap: getData,
                        borderSize: 0,
                        verticalPadding: 2,
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            // 'التواصل',
                            tr('contact'),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          settings != null &&
                                  settings['config_whatsapp'] != null
                              ? _item(
                                  image: Images.WhatsappIcon,
                                  // text: 'واتساب',
                                  text: tr('whatsapp'),
                                  onTap: () => _makePhoneCall(
                                    '${settings['config_whatsapp']}',
                                  ),
                                )
                              : Container(),
                          settings != null &&
                                  settings['store_telephone'] != null
                              ? _item(
                                  image: Images.TelegramIcon,
                                  // text: 'الجوال',
                                  text: tr('mobile'),
                                  onTap: () => _makePhoneCall(
                                    'tel:${settings['store_telephone']}',
                                  ),
                                )
                              : Container(),
                          settings != null && settings['store_email'] != null
                              ? _item(
                                  image: Images.TwitterIcon,
                                  // text: 'بريد الكتروني',
                                  text: tr('email'),
                                  onTap: () => showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      content: Text(settings['store_email']),
                                    ),
                                  ),
                                )
                              : Container(),
                          SizedBox(height: 20),
                          Text(
                            // 'حسابات اجتماعية',
                            tr('social media'),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          settings != null &&
                                  settings['config_facebook'] != null
                              ? _item(
                                  image: Images.TwitterIcon,
                                  // text: 'فيس بوك',
                                  text: tr('facebook'),
                                  onTap: () => _makePhoneCall(
                                    '${settings['config_facebook']}',
                                  ),
                                )
                              : Container(),
                          settings != null &&
                                  settings['config_instagram'] != null
                              ? _item(
                                  image: Images.InstagramIcon,
                                  // text: 'انستجرام',
                                  text: tr('instagram'),
                                  onTap: () => _makePhoneCall(
                                    '${settings['config_instagram']}',
                                  ),
                                )
                              : Container(),
                          settings != null && settings['config_twitter'] != null
                              ? _item(
                                  image: Images.TwitterIcon,
                                  // text: 'تويتر',
                                  text: tr('twitter'),
                                  onTap: () => _makePhoneCall(
                                    '${settings['config_twitter']}',
                                  ),
                                )
                              : Container(),
                          settings != null &&
                                  settings['config_snapchat'] != null
                              ? _item(
                                  image: Images.SnapchatIcon,
                                  // text: 'سناب شات',
                                  text: tr('snapchat'),
                                  onTap: () => _makePhoneCall(
                                    '${settings['config_snapchat']}',
                                  ),
                                )
                              : Container(),
                        ],
                      ),
            SizedBox(height: 20),
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : pages.length > 0
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            // 'صفحات تعريفية',
                            tr('info'),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Column(
                            children: List.generate(
                              pages.length,
                              (index) => _item(
                                  text: pages[index]['title'],
                                  onTap: () {
                                    Navigator.of(context).push(
                                      PageRouteBuilder(
                                        pageBuilder: (_, __, ___) => PageScreen(
                                          pages[index]['id'],
                                          pages[index]['title'],
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
                                  }),
                            ),
                          )
                        ],
                      )
                    : SecondaryButton(
                        // title: 'الصفحات التعريفية',
                        title: tr('info'),
                        onTap: getData,
                        borderSize: 0,
                        verticalPadding: 2,
                      ),
            SizedBox(height: 20),
            Text(
              // 'الاعدادات',
              tr('settings'),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            // Container(
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(8),
            //   ),
            //   child: BlocBuilder<ConfigCubit, ConfigState>(
            //     builder: (context, state) {
            //       if (state is GetConfigDone) {
            //         if (state.currencies.length > 0) {
            //           return Padding(
            //             padding:
            //                 EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            //             child: DropdownButton<String>(
            //               hint: Text(tr('currency')),
            //               value: state.selectedCurrency != ''
            //                   ? state.selectedCurrency
            //                   : null,
            //               isExpanded: true,
            //               onChanged: (value) {
            //                 print(value);
            //                 selectedCurrency = value!;
            //                 Globals.selectedCurrency = value;
            //                 BlocProvider.of<ConfigCubit>(context)
            //                     .updateSelectedCurrency(selectedCurrency);
            //               },
            //               items: state.currencies.map((category) {
            //                 return DropdownMenuItem(
            //                   value: category.title,
            //                   child: Text(
            //                     category.title ?? '',
            //                     style: TextStyle(
            //                       color: Color(0xffBFBFBF),
            //                     ),
            //                   ),
            //                 );
            //               }).toList(),
            //             ),
            //           );
            //         } else {
            //           return TextButton(
            //             style: ButtonStyle(
            //               padding: MaterialStateProperty.resolveWith<
            //                   EdgeInsetsGeometry>(
            //                 (Set<MaterialState> states) {
            //                   return EdgeInsets.symmetric(
            //                       vertical: 0, horizontal: 0);
            //                 },
            //               ),
            //             ),
            //             onPressed: () => BlocProvider.of<ConfigCubit>(context)
            //                 .getcurrencies(),
            //             child: Text(tr('load currency')),
            //           );
            //         }
            //       } else {
            //         return TextButton(
            //           style: ButtonStyle(
            //             padding: MaterialStateProperty.resolveWith<
            //                 EdgeInsetsGeometry>(
            //               (Set<MaterialState> states) {
            //                 return EdgeInsets.symmetric(
            //                   vertical: 0,
            //                   horizontal: 0,
            //                 );
            //               },
            //             ),
            //           ),
            //           onPressed: () =>
            //               BlocProvider.of<ConfigCubit>(context).getcurrencies(),
            //           child: Text(tr('load currency')),
            //         );
            //       }
            //     },
            //   ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Expanded(
            //       child: Row(
            //         children: [
            //           Container(
            //             padding: EdgeInsets.all(8),
            //             decoration: BoxDecoration(
            //               border: Border.all(
            //                 color: Color(0xffBFBFBF),
            //               ),
            //               borderRadius: BorderRadius.circular(4),
            //             ),
            //             child: Image.asset(
            //               Images.MoneyIcon,
            //               width: 15,
            //               fit: BoxFit.cover,
            //             ),
            //           ),
            //           SizedBox(width: 10),
            //           Text(
            //             'ريال سعودي',
            //             style: TextStyle(
            //               color: Color(0xffBFBFBF),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //     Row(
            //       children: [
            //         Container(
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(4),
            //           ),
            //           child: Image.asset(
            //             Images.Saudi,
            //             width: 35,
            //             fit: BoxFit.cover,
            //           ),
            //         ),
            //         Transform(
            //           transform: Matrix4.rotationY(3),
            //           child: Icon(
            //             Icons.arrow_back_ios_sharp,
            //             color: Color(0xffBFBFBF),
            //             size: 16,
            //           ),
            //         ),
            //         SizedBox(width: 10),
            //       ],
            //     ),
            //   ],
            // ),
            // ),
            Globals.allCurrencies.length != 0
                ? BlocBuilder<CurrencyBloc, CurrencyState>(
                    builder: (context, state) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: DropdownButton<String>(
                            hint: Text(tr('currency')),
                            value: state is CurrencyUpdated
                                ? state.currency
                                : null,
                            isExpanded: true,
                            onChanged: (value) {
                              BlocProvider.of<CurrencyBloc>(context)
                                  .add(ChangeCurrency(value));
                              setState(() {});
                            },
                            items: List.generate(
                              Globals.allCurrencies.length,
                              (index) {
                                final item = Globals.allCurrencies[index];

                                return DropdownMenuItem(
                                  value: item.code,
                                  child: Text(
                                    item.title ?? '',
                                    style: TextStyle(
                                      color: Color(0xffBFBFBF),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : TextButton(
                    style: ButtonStyle(
                      padding:
                          MaterialStateProperty.resolveWith<EdgeInsetsGeometry>(
                        (Set<MaterialState> states) {
                          return EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 0,
                          );
                        },
                      ),
                    ),
                    onPressed: () => BlocProvider.of<CurrencyBloc>(context)
                        .add(LoadCurrencies()),
                    child: Text(tr('load currency')),
                  ),
            Globals.allLanguages.length != 0
                ? BlocBuilder<LanguageBloc, LanguageState>(
                    builder: (context, state) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: DropdownButton<String>(
                            hint: Text(tr('language')),
                            value: state is LanguageUpdated
                                ? state.locale.languageCode
                                : null,
                            isExpanded: true,
                            onChanged: (value) {
                              if (value!.contains('en')) {
                                context.locale = Locale('en');
                              } else {
                                context.locale = Locale('ar');
                              }

                              BlocProvider.of<LanguageBloc>(context)
                                  .add(ChangeLanguage(Locale(value)));
                              setState(() {});
                            },
                            items: List.generate(
                              Globals.allLanguages.length,
                              (index) {
                                final item = Globals.allLanguages[index];

                                return DropdownMenuItem(
                                  value: item.code,
                                  child: Text(
                                    item.name ?? '',
                                    style: TextStyle(
                                      color: Color(0xffBFBFBF),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : TextButton(
                    style: ButtonStyle(
                      padding:
                          MaterialStateProperty.resolveWith<EdgeInsetsGeometry>(
                        (Set<MaterialState> states) {
                          return EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 0,
                          );
                        },
                      ),
                    ),
                    onPressed: () {
                      BlocProvider.of<LanguageBloc>(context)
                          .add(LoadLanguages());

                      setState(() {});
                    },
                    child: Text(tr('load languages')),
                  ),
            SizedBox(height: 15),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is Authenticated) {
                  return GestureDetector(
                    onTap: () =>
                        BlocProvider.of<AuthBloc>(context).add(Logout()),
                    child: _item(
                      image: Images.StarIcon,
                      text: 'تسجيل الخروج',
                    ),
                  );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
