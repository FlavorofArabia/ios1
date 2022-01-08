import 'package:easy_localization/easy_localization.dart';
import 'package:flavor/blocs/currencies/currencies_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../screens/main_navigation/main_navigation.dart';
import '../../components/primary_button.dart';
import '../../config/config.dart';
import '../../screens/cart/add_address.dart';
import '../../api/api.dart';
import '../../api/restful_api/checkout_api.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../components/secodary_button.dart';
import '../../models/checkout.dart';
import '../../models/country.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  List dummyAddresses = [
    {
      'name': 'الرياض السعودية',
      'description': 'حي النعيم - شارع السلام',
    },
    {
      'name': 'الرياض السعودية',
      'description': 'حي النعيم - شارع السلام',
    },
  ];

  int? selectedAddress;

  List dummyShipping = [
    'خدمة التوصيل لباب البيت',
    'سمسا (5- 1) أيام عمل',
  ];
  int? selectedDummyShipping;
  int? selectedDummyPayment;

  List<Shipping>? shipping = [];
  List<int>? selectedShippingIndex;
  List<Payment> payment = [];
  int? selectedPayment;

  @override
  void initState() {
    getCheckoutData();
    // getAddresses();
    super.initState();
  }

  bool _gettingCheckoutData = false;
  getCheckoutData() async {
    try {
      shipping = [];
      payment = [];
      addresses = [];

      if (mounted) {
        setState(() {
          _gettingAddress = true;
          _gettingCheckoutData = true;
        });
      }

      final res = await CheckoutApi.generateCheckoutData();
      if (res['data'] != null) {
        List parsedPayment = res['data']['payment'];
        for (var i = 0; i < parsedPayment.length; i++) {
          payment.add(Payment.fromMap(parsedPayment[i]));
        }

        List parsedShipping = res['data']['shipping'];
        for (var i = 0; i < parsedShipping.length; i++) {
          shipping!.add(Shipping.fromMap(parsedShipping[i]));
        }
        List parsedAddresses = res['data']['addresses'];
        for (var i = 0; i < parsedAddresses.length; i++) {
          addresses.add(Address.fromMap(parsedAddresses[i]));
        }
      }

      if (mounted) {
        setState(() {
          _gettingCheckoutData = false;
          _gettingAddress = false;
        });
      }
    } catch (err) {
      print(err);
      if (mounted) {
        setState(() {
          _gettingCheckoutData = false;
          _gettingAddress = false;
        });
      }
    }
  }

  List<Address> addresses = [];
  bool _gettingAddress = false;
  getAddresses() async {
    try {
      addresses = [];
      if (mounted) {
        setState(() {
          _gettingAddress = true;
        });
      }
      final res = await AuthApi.getAddresses();
      if (res['data'] != null) {
        if (res['data']['addresses'] != null) {
          for (var i = 0; i < res['data']['addresses'].length; i++) {
            addresses.add(Address.fromMap(res['data']['addresses'][i]));
          }
        }
      }

      if (mounted) {
        setState(() {
          _gettingAddress = false;
        });
      }
    } catch (err) {
      print(err);
      if (mounted) {
        setState(() {
          _gettingAddress = false;
        });
      }
    }
  }

  deleteAddress(addressId) async {
    try {
      addresses = [];
      if (mounted) {
        setState(() {
          _gettingAddress = true;
        });
      }
      final res = await AuthApi.deleteAddress(addressId);
      if (res['data'] != null) {
        selectedAddress = null;
        getAddresses();
      }

      if (mounted) {
        setState(() {
          _gettingAddress = false;
        });
      }
    } catch (err) {
      print(err);
      if (mounted) {
        setState(() {
          _gettingAddress = false;
        });
      }
    }
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  _displaySnackBar(BuildContext context, String txt, {Color? color}) {
    final snackBar = SnackBar(
      backgroundColor: color ?? Colors.redAccent,
      content:
          // Directionality(
          // textDirection: TextDirection.rtl,
          // child:
          Text(txt),
      // ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  bool confirming = false;
  confirmOrder() async {
    if (selectedAddress == null) {
      return _displaySnackBar(context, 'اختر العنوان');
    }
    if (selectedShippingIndex == null) {
      return _displaySnackBar(context, 'اختر شركة الشحن');
    }
    if (selectedPayment == null) {
      return _displaySnackBar(context, 'اختر طريقة الدفع');
    }
    try {
      if (mounted) {
        setState(() {
          confirming = true;
        });
      }
      // print('step 2');
      // var setAddress = await CheckoutApi.setNewAddress(
      //   {
      //     ...addresses[selectedAddress].toJson(),
      //     'name': Globals.user.firstName + ' ' + Globals.user.lastName,
      //     'telephone': Globals.user.telephone,
      //   },
      // );
      // if (setAddress['error'] != null && setAddress['error'].length > 0) {
      //   if (mounted) {
      //     setState(() {
      //       confirming = false;
      //     });
      //   }
      //   return _displaySnackBar(context, setAddress['error'][0]);
      // }
      print('step 2');
      var setAddress = await CheckoutApi.setExistingAddress(
        {"address_id": addresses[selectedAddress!].addressId},
      );
      if (setAddress['error'] != null && setAddress['error'].length > 0) {
        if (mounted) {
          setState(() {
            confirming = false;
          });
        }
        return _displaySnackBar(context, setAddress['error'][0]);
      } else if (setAddress['message'] != null && setAddress['data'] == null) {
        if (mounted) {
          setState(() {
            confirming = false;
          });
        }
        return _displaySnackBar(context, setAddress['message']);
      }
      print('step 3');
      var setShippingMethod = await CheckoutApi.setShippingMethod(
        {
          'shipping_method': shipping![selectedShippingIndex![0]]
              .quote![selectedShippingIndex![1]]
              .code,
          'comment': '',
        },
      );
      if (setShippingMethod['error'] != null &&
          setShippingMethod['error'].length > 0) {
        if (mounted) {
          setState(() {
            confirming = false;
          });
        }
        return _displaySnackBar(context, setShippingMethod['error'][0]);
      } else if (setShippingMethod['message'] != null &&
          setShippingMethod['data'] == null) {
        if (mounted) {
          setState(() {
            confirming = false;
          });
        }
        return _displaySnackBar(context, setShippingMethod['message']);
      }
      print('step 4');
      var setPaymentMethod = await CheckoutApi.setPaymentMethod({
        'payment_method': payment[selectedPayment!].code,
      });
      if (setPaymentMethod['error'] != null &&
          setPaymentMethod['error'].length > 0) {
        if (mounted) {
          setState(() {
            confirming = false;
          });
        }

        return _displaySnackBar(context, setPaymentMethod['error'][0]);
      } else if (setPaymentMethod['message'] != null &&
          setPaymentMethod['data'] == null) {
        if (mounted) {
          setState(() {
            confirming = false;
          });
        }
        return _displaySnackBar(context, setPaymentMethod['message']);
      }

      if (payment[selectedPayment!].code != 'tap') {
        var orderConfirm = await CheckoutApi.orderConfirm({});
        if (orderConfirm['error'] != null && orderConfirm['error'].length > 0) {
          if (mounted) {
            setState(() {
              confirming = false;
            });
          }

          return _displaySnackBar(context, orderConfirm['error'][0]);
        } else if (orderConfirm['message'] != null &&
            orderConfirm['data'] == null) {
          if (mounted) {
            setState(() {
              confirming = false;
            });
          }
          return _displaySnackBar(context, orderConfirm['message']);
        }

        var finishOrder = await CheckoutApi.finishOrder({});
        if (finishOrder['error'] != null && finishOrder['error'].length > 0) {
          if (mounted) {
            setState(() {
              confirming = false;
            });
          }

          return _displaySnackBar(context, finishOrder['error'][0]);
        } else if (finishOrder['message'] != null &&
            finishOrder['data'] == null) {
          if (mounted) {
            setState(() {
              confirming = false;
            });
          }
          return _displaySnackBar(context, finishOrder['message']);
        }
        print(finishOrder);
        BlocProvider.of<CartBloc>(context).add(LoadCart());
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) =>
                // Directionality(
                //   textDirection: TextDirection.rtl,
                //   child:
                MainNavigation(tabIndex: 4),
            // ),
            transitionDuration: Duration(milliseconds: 500),
            transitionsBuilder:
                (_, Animation<double> animation, __, Widget child) {
              return Opacity(
                opacity: animation.value,
                child: child,
              );
            },
          ),
        );
      } else {
        var payWebview = await CheckoutApi.forPaymentByUsingWebView();
        print(payWebview);
        if (payWebview['error'] != null && payWebview['error'].length > 0) {
          setState(() {
            confirming = false;
          });
          return _displaySnackBar(context, payWebview['error'][0]);
        }
      }

      if (mounted) {
        setState(() {
          confirming = false;
        });
      }
    } catch (err) {
      print(err);
      if (mounted) {
        setState(() {
          confirming = false;
        });
      }
    }
  }

  String coupon = '';
  bool applyingCoupon = false;
  applyCoupon() async {
    try {
      if (mounted) {
        setState(() {
          applyingCoupon = true;
        });
      }

      var applyCoupon = await CheckoutApi.applyCoupon(
        {"coupon": coupon},
      );
      if (applyCoupon['data'] == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(applyCoupon['message']),
          backgroundColor: Colors.red,
        ));
      }
      if (mounted) {
        setState(() {
          applyingCoupon = false;
        });
      }
    } catch (err) {
      print(err);
      if (mounted) {
        setState(() {
          applyingCoupon = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return
        // Directionality(
        //   textDirection: TextDirection.rtl,
        //   child:
        Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          // 'الشحن',
          tr('checkout'),
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
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  child: Text(
                    // 'معلومات التوصيل والاستلام',
                    tr('shipping information'),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      _gettingAddress
                          ? Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : addresses.length == 0
                              ? SecondaryButton(
                                  title: 'العناوين السابقة',
                                  onTap: getAddresses,
                                  borderSize: 0,
                                  verticalPadding: 2,
                                )
                              : Column(
                                  children: List.generate(
                                    addresses.length,
                                    (index) => GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedAddress = index;
                                        });
                                      },
                                      child: Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 10),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        decoration: BoxDecoration(
                                          color: Color(0xffF8F9F3),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: selectedAddress != null &&
                                                  selectedAddress == index
                                              ? Border.all(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                )
                                              : null,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                selectedAddress != null &&
                                                        selectedAddress == index
                                                    ? Row(
                                                        children: [
                                                          Image.asset(
                                                              Images.Check),
                                                          SizedBox(width: 10)
                                                        ],
                                                      )
                                                    : Container(),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      addresses[index].country!,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Text(
                                                      addresses[index].zone! +
                                                          (addresses[index]
                                                                      .city !=
                                                                  ''
                                                              ? ' - ${addresses[index].city}'
                                                              : ''),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Image.asset(
                                                  Images.EditAddress,
                                                  width: 20,
                                                ),
                                                SizedBox(height: 15),
                                                GestureDetector(
                                                  onTap: () {
                                                    deleteAddress(
                                                        addresses[index]
                                                            .addressId);
                                                  },
                                                  child: Image.asset(
                                                    Images.DeleteAddress,
                                                    width: 20,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) =>
                                  AddAddressScreen(getAddresses),
                              transitionDuration: Duration(milliseconds: 500),
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
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Color(0xffF8F9F3),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            children: [
                              Image.asset(Images.DropPin),
                              SizedBox(width: 10),
                              Text(
                                'اضافة عنوان جديد',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Column(
                  children: [
                    Container(
                      child: Text(
                        // 'اختر شركة الشحن',
                        tr('select shipping method'),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    _gettingCheckoutData
                        ? Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : shipping!.length == 0
                            ? Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Center(
                                  child: IconButton(
                                    icon: Icon(Icons.refresh),
                                    onPressed: getCheckoutData,
                                  ),
                                ),
                              )
                            : Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    Column(
                                      children: List.generate(
                                        shipping!.length,
                                        (index) => Column(
                                          children: List.generate(
                                            shipping![index].quote!.length,
                                            (i) => GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selectedShippingIndex = [
                                                    index,
                                                    i
                                                  ];
                                                });
                                              },
                                              child: Container(
                                                margin: EdgeInsets.symmetric(
                                                  vertical: 10,
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 10,
                                                  horizontal: 10,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Color(0xffF8F9F3),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    5,
                                                  ),
                                                  border: selectedShippingIndex !=
                                                              null &&
                                                          (selectedShippingIndex![
                                                                      0] ==
                                                                  index &&
                                                              selectedShippingIndex![
                                                                      1] ==
                                                                  i)
                                                      ? Border.all(
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                        )
                                                      : null,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        selectedShippingIndex !=
                                                                    null &&
                                                                (selectedShippingIndex![
                                                                            0] ==
                                                                        index &&
                                                                    selectedShippingIndex![
                                                                            1] ==
                                                                        i)
                                                            ? Row(
                                                                children: [
                                                                  Image.asset(
                                                                      Images
                                                                          .Check),
                                                                  SizedBox(
                                                                      width: 10)
                                                                ],
                                                              )
                                                            : Container(),
                                                        Text(shipping![index]
                                                            .quote![i]
                                                            .title!),
                                                      ],
                                                    ),
                                                    Text(
                                                      shipping![index]
                                                          .quote![i]
                                                          .text!,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(tr('cart summary')),
                                // Text('ملخص السنة'),
                                // Text('240 ريال'),
                                BlocBuilder<CartBloc, CartState>(
                                  builder: (context, state) {
                                    if (state is CartLoaded) {
                                      return BlocBuilder<CurrencyBloc,
                                          CurrencyState>(
                                        builder: (context, currencyState) {
                                          return Text(
                                            '${state.totalParsedPrice.toStringAsFixed(0)} ' +
                                                (currencyState
                                                        is CurrencyUpdated
                                                    ? currencyState.currency
                                                    : ''),
                                          );
                                        },
                                      );
                                    }
                                    return Container();
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Divider(),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(tr('shipping cost')),
                                // Text('تكلفة الشحن'),
                                Text(
                                  selectedShippingIndex != null
                                      ? shipping![selectedShippingIndex![0]]
                                          .quote![selectedShippingIndex![1]]
                                          .text!
                                      // : 'اختر الشحن',
                                      : tr('select shipping method'),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            // Divider(),
                            // SizedBox(height: 5),
                            // Row(
                            //   mainAxisAlignment:
                            //       MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Text('الضريبة'),
                            //     Text('240 ريال'),
                            //   ],
                            // ),
                            // SizedBox(height: 5),
                            Divider(),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  // 'السعر الاجمالي',
                                  tr('total cost'),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // Text('240 ريال'),
                                BlocBuilder<CartBloc, CartState>(
                                  builder: (context, state) {
                                    if (state is CartLoaded) {
                                      return BlocBuilder<CurrencyBloc,
                                          CurrencyState>(
                                        builder: (context, currencyState) {
                                          return Text(
                                            selectedShippingIndex != null
                                                ? '${(state.totalParsedPrice + double.tryParse(shipping![selectedShippingIndex![0]].quote![selectedShippingIndex![1]].cost!)!.toDouble()).toStringAsFixed(0)} ' +
                                                    (currencyState
                                                            is CurrencyUpdated
                                                        ? currencyState.currency
                                                        : '')
                                                // : 'اختر الشحن',
                                                : tr('select shipping method'),
                                          );
                                        },
                                      );
                                    }
                                    return Container();
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Divider(),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'لديك كوبون خصم؟',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                SizedBox(width: 15),
                                Expanded(
                                  child: Material(
                                    shadowColor: Color(0xffF6F6F6),
                                    borderRadius: BorderRadius.circular(8),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 0,
                                        ),
                                        labelText: 'ادخل الكوبون',
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                      ),
                                      onChanged: (String value) {
                                        coupon = value;
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15),
                                applyingCoupon
                                    ? CircularProgressIndicator()
                                    : PrimaryButton(
                                        backColor:
                                            Theme.of(context).primaryColor,
                                        padding: 5,
                                        title: 'تطبيق',
                                        textWeight: FontWeight.w300,
                                        onTap: applyCoupon,
                                      ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      child: Text(
                        tr('select payment method'),
                        // 'اختر طريقة الدفع',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    _gettingCheckoutData
                        ? Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : payment.length == 0
                            ? Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Center(
                                  child: IconButton(
                                    icon: Icon(Icons.refresh),
                                    onPressed: getCheckoutData,
                                  ),
                                ),
                              )
                            : Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.symmetric(vertical: 10),
                                padding: EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Wrap(
                                    children: List.generate(
                                      payment.length,
                                      (index) => Container(
                                        width:
                                            (MediaQuery.of(context).size.width /
                                                    2 -
                                                40),
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedPayment = index;
                                            });
                                          },
                                          child: Container(
                                            height: 100,
                                            decoration: BoxDecoration(
                                              color: Color(0xffF8F9F3),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: selectedPayment != null &&
                                                      selectedPayment == index
                                                  ? Border.all(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                    )
                                                  : null,
                                            ),
                                            child: Stack(
                                              children: [
                                                selectedPayment == index
                                                    ? Positioned(
                                                        top: 5,
                                                        right: 5,
                                                        child: Image.asset(
                                                            Images.Check),
                                                      )
                                                    : Container(),
                                                Center(
                                                  child: payment[index]
                                                          .title!
                                                          .contains('img')
                                                      ? Container(
                                                          width:
                                                              double.infinity,
                                                          child: Html(
                                                              data:
                                                                  payment[index]
                                                                      .title),
                                                        )
                                                      : Text(payment[index]
                                                          .title!),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                  ],
                ),
                SizedBox(height: 10),
                confirming
                    ? Center(child: CircularProgressIndicator())
                    : PrimaryButton(
                        backColor: Theme.of(context).primaryColor,
                        height: 30,
                        // title: 'تأكيد الدفع',
                        title: tr('confirm payment'),
                        textWeight: FontWeight.bold,
                        onTap: confirmOrder,
                      ),
              ],
            ),
          ),
        ),
      ),
      // ),
    );
  }
}
