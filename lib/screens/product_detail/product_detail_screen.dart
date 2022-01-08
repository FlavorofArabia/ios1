import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';

import '../../api/restful_api/product_api.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../components/secodary_button.dart';
import '../../config/global.dart';
import '../../screens/main_navigation/main_navigation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../components/primary_button.dart';
import '../../config/images.dart';
import '../../models/product.dart';

import './product_item.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  // final List<Product> similarProducts;
  ProductDetailScreen({
    required this.product,
    // this.similarProducts,
  });

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return
        // Directionality(
        //   textDirection: TextDirection.rtl,
        //   child:
        Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.product.name!,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'GE',
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Wrap(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 3,
                    child: widget.product.images != null &&
                            widget.product.images!.length > 1
                        ? ListView(
                            scrollDirection: Axis.horizontal,
                            children: List.generate(
                              widget.product.images!.length,
                              (i) => GestureDetector(
                                onTap: () {},
                                child: new Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom:
                                          BorderSide(color: Color(0xffe2e2e2)),
                                    ),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: widget.product.images != null &&
                                            widget.product.images!.length > 0
                                        ? widget.product.images![i]
                                        : 'https://via.placeholder.com/350x150',
                                    fit: BoxFit.contain,
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) =>
                                            Center(
                                      child: CircularProgressIndicator(
                                        value: downloadProgress.progress,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Center(child: Icon(Icons.error)),
                                    fadeInCurve: Curves.easeInOut,
                                    fadeInDuration: Duration(milliseconds: 500),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : new Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Color(0xffe2e2e2)),
                              ),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: widget.product.image != null
                                  ? widget.product.image!
                                  : '',
                              fit: BoxFit.cover,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => Center(
                                child: CircularProgressIndicator(
                                  value: downloadProgress.progress,
                                ),
                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                Images.SliderImage,
                                fit: BoxFit.cover,
                              ),
                              fadeInCurve: Curves.easeInOut,
                              fadeInDuration: Duration(milliseconds: 500),
                            ),
                          ),
                  ),
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      children: [
                        Text(
                          widget.product.name! + ' ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff55311B),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.product.priceFormated ?? '',
                          style: TextStyle(
                            height: 1.3,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(width: 5),
                        widget.product.priceExcludingTaxFormated !=
                                widget.product.priceFormated
                            ? Text(
                                widget.product.priceExcludingTaxFormated ?? '',
                                style: TextStyle(
                                  height: 1.3,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              )
                            : Container(),
                      ],
                    ),
                    SizedBox(height: 10),
                    Divider(),
                    SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tr('product details'),
                          // 'تفاصيل المنتج',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        widget.product != null &&
                                widget.product.description != null
                            ? Html(
                                data: widget.product.description,
                                style: {
                                  "div": Style(
                                    fontFamily: 'GE',
                                    fontSize: FontSize.em(1),
                                  ),
                                  "span": Style(
                                    fontFamily: 'GE',
                                  ),
                                  "b": Style(
                                    fontFamily: 'GE',
                                  ),
                                  "p": Style(
                                    fontFamily: 'GE',
                                    fontSize: FontSize.rem(1),
                                  ),
                                  "li": Style(
                                    fontFamily: 'GE',
                                    fontSize: FontSize.rem(1),
                                  ),
                                },
                              )
                            : Container(),
                      ],
                    ),
                    widget.product.relatedProducts != null &&
                            widget.product.relatedProducts!.length > 0
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              Divider(),
                              SizedBox(height: 10),
                              Text(
                                tr('similar products'),
                                // 'منتجات قد تعجبك',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                height: 230,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      widget.product.relatedProducts!.length,
                                  itemBuilder: (context, index) => ProductItem(
                                    product:
                                        widget.product.relatedProducts![index],
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Container()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            new BoxShadow(
              color: Colors.black12,
              offset: new Offset(0.0, 0.0),
              blurRadius: 2.0,
              spreadRadius: 1.0,
            )
          ],
        ),
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (ctx, authState) {
            if (authState is Authenticated) {
              return BlocConsumer<CartBloc, CartState>(
                listener: (ctx, state) {
                  if (state is CartLoaded) {
                    if (widget.product.options!.length == 0) {
                      if (state.updated != null && state.updated!) {
                        return Globals.addToCart(context);
                        // return showModalBottomSheet(
                        //   context: context,
                        //   builder: (ctx) {
                        //     return Directionality(
                        //       textDirection: TextDirection.rtl,
                        //       child: Container(
                        //         padding: EdgeInsets.all(20),
                        //         decoration: BoxDecoration(
                        //           color: Colors.white,
                        //           borderRadius: BorderRadius.only(
                        //             topLeft: Radius.circular(10),
                        //             topRight: Radius.circular(10),
                        //           ),
                        //         ),
                        //         child: Center(
                        //           child: Column(
                        //             crossAxisAlignment:
                        //                 CrossAxisAlignment.center,
                        //             mainAxisAlignment:
                        //                 MainAxisAlignment.spaceEvenly,
                        //             children: [
                        //               Center(
                        //                 child: Image.asset(
                        //                   Images.AddedToCart,
                        //                   width: 120,
                        //                   height: 120,
                        //                   fit: BoxFit.fill,
                        //                 ),
                        //               ),
                        //               Text(
                        //                 'تمت الاضافة الي السلة',
                        //                 style: TextStyle(
                        //                   fontSize: 16,
                        //                   fontWeight: FontWeight.bold,
                        //                 ),
                        //               ),
                        //               Text(
                        //                 'هل ترغب في مواصلة التسوق أو فتح السلة؟',
                        //                 style: TextStyle(
                        //                   fontSize: 16,
                        //                   fontWeight: FontWeight.bold,
                        //                 ),
                        //               ),
                        //               Container(
                        //                 padding: EdgeInsets.all(8),
                        //                 decoration: BoxDecoration(
                        //                   color: Colors.white,
                        //                   borderRadius:
                        //                       BorderRadius.circular(10),
                        //                   boxShadow: [
                        //                     new BoxShadow(
                        //                       color: Colors.black12,
                        //                       offset: new Offset(0.0, 0.0),
                        //                       blurRadius: 2.0,
                        //                       spreadRadius: 1.0,
                        //                     )
                        //                   ],
                        //                 ),
                        //                 child: Row(
                        //                   children: [
                        //                     Expanded(
                        //                       child: SecondaryButton(
                        //                         title: 'مواصلة التسوق',
                        //                         horizontalPadding: 8,
                        //                         verticalPadding: 4,
                        //                         onTap: () =>
                        //                             Navigator.pop(context),
                        //                       ),
                        //                     ),
                        //                     SizedBox(width: 8),
                        //                     Expanded(
                        //                       child: PrimaryButton(
                        //                         title: 'عرض السلة',
                        //                         padding: 8,
                        //                         onTap: () {
                        //                           Navigator.popUntil(
                        //                             context,
                        //                             (route) => route.isFirst,
                        //                           );
                        //                           Navigator.of(context).push(
                        //                             PageRouteBuilder(
                        //                               pageBuilder:
                        //                                   (_, __, ___) =>
                        //                                       Directionality(
                        //                                 textDirection:
                        //                                     TextDirection.rtl,
                        //                                 child: MainNavigation(
                        //                                     tabIndex: 2),
                        //                               ),
                        //                               transitionDuration:
                        //                                   Duration(
                        //                                       milliseconds:
                        //                                           500),
                        //                               transitionsBuilder: (_,
                        //                                   Animation<double>
                        //                                       animation,
                        //                                   __,
                        //                                   Widget child) {
                        //                                 return Opacity(
                        //                                   opacity:
                        //                                       animation.value,
                        //                                   child: child,
                        //                                 );
                        //                               },
                        //                             ),
                        //                           );
                        //                         },
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       ),
                        //     );
                        //   },
                        // );
                      }
                    }
                  }
                  if (state is CartFailed) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (ctx, state) {
                  if (state is CartLoaded) {
                    return PrimaryButton(
                      padding: 5,
                      textSize: 16,
                      textWeight: FontWeight.bold,
                      title: tr('add to cart'),
                      // title: "أضف للسلة",
                      onTap: () {
                        if (widget.product.options!.length > 0) {
                          showModalBottomSheet(
                            context: ctx,
                            builder: (ctx) {
                              return
                                  // Directionality(
                                  //   textDirection: TextDirection.rtl,
                                  //   child:
                                  OptionsSection(
                                ctx, widget.product, [],
                                // ),
                              );
                            },
                          );
                        } else {
                          BlocProvider.of<CartBloc>(context).add(
                            AddItem(
                              productId: widget.product.id,
                              quantity: 1,
                            ),
                          );
                        }
                      },
                    );
                  } else if (state is CartLoading) {
                    return Container(
                      height: 50,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return PrimaryButton(
                    padding: 5,
                    textSize: 16,
                    textWeight: FontWeight.bold,
                    title: tr('cart'),
                    // title: "السلة",
                    onTap: () {
                      BlocProvider.of<CartBloc>(context).add(LoadCart());
                    },
                  );
                },
              );
            } else {
              return Builder(
                builder: (context) {
                  return PrimaryButton(
                    padding: 5,
                    textSize: 16,
                    textWeight: FontWeight.bold,
                    title: tr('cart'),
                    // title: "السلة",
                    onTap: () {
                      Globals.auth(context);
                    },
                  );
                },
              );
            }
          },
        ),
      ),
      // ),
    );
  }
}

class OptionsSection extends StatefulWidget {
  final BuildContext c;
  final Product product;
  final List<dynamic> initValuesIds;
  OptionsSection(
    this.c,
    this.product,
    this.initValuesIds,
  );

  @override
  _OptionsSectionState createState() => _OptionsSectionState();
}

class _OptionsSectionState extends State<OptionsSection> {
  int qty = 1;
  List<dynamic> selectedValuesIds = [];

  BuildContext? c;
  @override
  void initState() {
    c = widget.c;

    selectedValuesIds = widget.initValuesIds;
    if (selectedValuesIds.length == 0 &&
        widget.product != null &&
        widget.product.options is Iterable) {
      for (var i = 0; i < widget.product.options!.length; i++) {
        selectedValuesIds.add(null);
      }
    }
    price = widget.product.priceFormated!;
    super.initState();
  }

  String price = '';
  bool _gettingPrice = false;
  getPrice() async {
    try {
      if (mounted) {
        setState(() {
          _gettingPrice = true;
        });
      }
      Map options = {};
      if (widget.product.options!.length > 0) {
        for (var i = 0; i < selectedValuesIds.length; i++) {
          for (var i = 0; i < selectedValuesIds.length; i++) {
            options[widget.product.options![i].id.toString()] =
                selectedValuesIds[i];
          }
        }
      }
      final res = await ProductApi.productLivePrice(
        widget.product.productId,
        {'option': options},
      );

      if (res['data'] != null) {
        setState(() {
          price = res['data']['price'];
        });
      }
      if (mounted) {
        setState(() {
          _gettingPrice = false;
        });
      }
    } catch (err) {
      print(err);
      if (mounted) {
        setState(() {
          _gettingPrice = false;
        });
      }
    }
  }

  bool _addedToCart = false;

  @override
  Widget build(BuildContext ctx) {
    return _addedToCart
        ?
        // Directionality(
        //     textDirection: TextDirection.rtl,
        //     child:
        Container(
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
                                  pageBuilder: (_, __, ___) =>
                                      // Directionality(
                                      //   textDirection: TextDirection.rtl,
                                      //   child:
                                      MainNavigation(tabIndex: 2),
                                  // ),
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
            // ),
          )
        : Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: ListView(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      width: 70,
                      height: 70,
                      child: CachedNetworkImage(
                        imageUrl: widget.product.image != null
                            ? widget.product.image!
                            : '',
                        fit: BoxFit.fill,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => Center(
                          child: CircularProgressIndicator(
                            value: downloadProgress.progress,
                          ),
                        ),
                        errorWidget: (context, url, error) => Center(
                          child: Center(child: Icon(Icons.error)),
                        ),
                        fadeInCurve: Curves.easeInOut,
                        fadeInDuration: Duration(milliseconds: 500),
                      ),
                    ),
                    Expanded(
                      child: new Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.product.name!,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            _gettingPrice
                                ? LinearProgressIndicator()
                                : Text(
                                    price.contains('س.ر')
                                        ? (int.tryParse(price
                                                        .split('س.ر')[0])! *
                                                    qty)
                                                .toString() +
                                            'س.ر'
                                        : price,
                                    // (widget.product.price * qty).toString() +
                                    //         ' ' +
                                    //         'ريال' ??
                                    //     '',
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'الكمية',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color(0xffF8F9F2),
                      ),
                      child: Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: widget.product != null &&
                                    widget.product.quantity != null &&
                                    widget.product.quantity! > qty
                                ? () {
                                    setState(() {
                                      qty += 1;
                                    });
                                  }
                                : null,
                            child: Container(
                              decoration: BoxDecoration(
                                color: widget.product != null &&
                                        widget.product.quantity != null &&
                                        widget.product.quantity! > qty
                                    ? Color(0xffF8F9F2)
                                    : Colors.grey,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 5,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.add,
                                  size: 20,
                                  color: widget.product != null &&
                                          widget.product.quantity != null &&
                                          widget.product.quantity! > qty
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 55,
                            color: Color(0xffF8F9F2),
                            child: Center(
                              child: Text(
                                '$qty',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (qty > 1) {
                                setState(() {
                                  qty -= 1;
                                });
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xffF8F9F2),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 5,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.remove,
                                  size: 20,
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
                Divider(color: Colors.grey),
                SizedBox(height: 10),
                Text('خيارات المنتج'),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Color(0xffF8F9F2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child:
                      widget.product != null &&
                              widget.product.options != null &&
                              widget.product.options is Iterable
                          ? Column(
                              children: List.generate(
                                widget.product.options!.length,
                                (optionIndex) => Column(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Text(
                                        widget.product.options![optionIndex]
                                                .name ??
                                            '',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    widget.product.options![optionIndex].type !=
                                                null &&
                                            (widget
                                                        .product
                                                        .options![optionIndex]
                                                        .type ==
                                                    'radio' ||
                                                widget
                                                        .product
                                                        .options![optionIndex]
                                                        .type ==
                                                    'select' ||
                                                widget
                                                        .product
                                                        .options![optionIndex]
                                                        .type ==
                                                    'checkbox')
                                        ? widget.product.options![optionIndex]
                                                    .type ==
                                                'select'
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15),
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: DropdownButton<String>(
                                                    isExpanded: true,
                                                    style: TextStyle(
                                                      fontFamily: 'GE',
                                                      fontSize: 14,
                                                    ),
                                                    hint: Text(
                                                      'اختر',
                                                      style: TextStyle(
                                                          fontFamily: 'GE'),
                                                    ),
                                                    value: selectedValuesIds[
                                                                optionIndex] !=
                                                            null
                                                        ? selectedValuesIds[
                                                                optionIndex]
                                                            .toString()
                                                        : null,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        selectedValuesIds[
                                                                optionIndex] =
                                                            value;
                                                      });
                                                      getPrice();
                                                    },
                                                    items: widget
                                                        .product
                                                        .options![optionIndex]
                                                        .values!
                                                        .map((x) {
                                                      return DropdownMenuItem(
                                                        // value: x.optionValueId
                                                        //     .toString(),
                                                        value: x
                                                            .productOptionValueId
                                                            .toString(),
                                                        child: Container(
                                                          width:
                                                              double.infinity,
                                                          child: Text(
                                                            x.name ?? '',
                                                            // textDirection:
                                                            //     TextDirection
                                                            //         .rtl,
                                                            style: TextStyle(
                                                              fontFamily: 'GE',
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                              )
                                            : Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: List.generate(
                                                  widget
                                                      .product
                                                      .options![optionIndex]
                                                      .values!
                                                      .length,
                                                  (index) => Container(
                                                    child: Row(
                                                      children: [
                                                        widget
                                                                    .product
                                                                    .options![
                                                                        optionIndex]
                                                                    .type ==
                                                                'radio'
                                                            ? Expanded(
                                                                child:
                                                                    Container(
                                                                  child:
                                                                      RadioListTile(
                                                                    title: Text(
                                                                      widget
                                                                          .product
                                                                          .options![
                                                                              optionIndex]
                                                                          .values![
                                                                              index]
                                                                          .name!,
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'GE',
                                                                        fontSize:
                                                                            14,
                                                                      ),
                                                                    ),
                                                                    // value: widget
                                                                    //     .product
                                                                    //     .options[
                                                                    //         optionIndex]
                                                                    //     .values[index]
                                                                    //     .optionValueId
                                                                    //     .toString(),
                                                                    value: widget
                                                                        .product
                                                                        .options![
                                                                            optionIndex]
                                                                        .values![
                                                                            index]
                                                                        .productOptionValueId
                                                                        .toString(),
                                                                    groupValue: selectedValuesIds[optionIndex] !=
                                                                            null
                                                                        ? selectedValuesIds[optionIndex]
                                                                            .toString()
                                                                        : '',
                                                                    onChanged:
                                                                        (value) {
                                                                      setState(
                                                                          () {
                                                                        selectedValuesIds[optionIndex] =
                                                                            value.toString();
                                                                      });
                                                                      getPrice();
                                                                    },
                                                                    activeColor:
                                                                        Theme.of(context)
                                                                            .primaryColor,
                                                                  ),
                                                                ),
                                                              )
                                                            : widget
                                                                        .product
                                                                        .options![
                                                                            optionIndex]
                                                                        .type ==
                                                                    'checkbox'
                                                                ? Expanded(
                                                                    child:
                                                                        Container(
                                                                      child:
                                                                          CheckboxListTile(
                                                                        title:
                                                                            Text(
                                                                          widget.product.options![optionIndex].values![index].name ??
                                                                              '',
                                                                          style:
                                                                              TextStyle(
                                                                            fontFamily:
                                                                                'GE',
                                                                            fontSize:
                                                                                14,
                                                                          ),
                                                                        ),
                                                                        // value: selectedValuesIds[optionIndex] !=
                                                                        //             null &&
                                                                        //         selectedValuesIds[optionIndex]
                                                                        //             is Iterable
                                                                        //     ? selectedValuesIds[
                                                                        //             optionIndex]
                                                                        //         .contains(
                                                                        //         widget
                                                                        //             .product
                                                                        //             .options[optionIndex]
                                                                        //             .values[index]
                                                                        //             .optionValueId
                                                                        //             .toString(),
                                                                        //       )
                                                                        //     : false,
                                                                        value: selectedValuesIds[optionIndex] != null &&
                                                                                selectedValuesIds[optionIndex] is Iterable
                                                                            ? selectedValuesIds[optionIndex].contains(
                                                                                widget.product.options![optionIndex].values![index].productOptionValueId.toString(),
                                                                              )
                                                                            : false,
                                                                        activeColor:
                                                                            Theme.of(context).primaryColor,
                                                                        onChanged:
                                                                            (value) {
                                                                          // if (value) {

                                                                          //   if (selectedValuesIds[
                                                                          //           optionIndex] !=
                                                                          //       null) {
                                                                          //     if (!selectedValuesIds[optionIndex].contains(widget
                                                                          //         .product
                                                                          //         .options[optionIndex]
                                                                          //         .values[index]
                                                                          //         .optionValueId
                                                                          //         .toString())) {
                                                                          //       selectedValuesIds[optionIndex].add(widget
                                                                          //           .product
                                                                          //           .options[optionIndex]
                                                                          //           .values[index]
                                                                          //           .optionValueId
                                                                          //           .toString());
                                                                          //     }
                                                                          //   } else {
                                                                          //     selectedValuesIds[
                                                                          //         optionIndex] = [
                                                                          //       widget
                                                                          //           .product
                                                                          //           .options[optionIndex]
                                                                          //           .values[index]
                                                                          //           .optionValueId
                                                                          //           .toString()
                                                                          //     ];
                                                                          //   }
                                                                          // } else {
                                                                          //   if (selectedValuesIds[optionIndex].contains(widget
                                                                          //       .product
                                                                          //       .options[
                                                                          //           optionIndex]
                                                                          //       .values[
                                                                          //           index]
                                                                          //       .optionValueId
                                                                          //       .toString())) {
                                                                          //     selectedValuesIds[optionIndex].remove(widget
                                                                          //         .product
                                                                          //         .options[optionIndex]
                                                                          //         .values[index]
                                                                          //         .optionValueId
                                                                          //         .toString());
                                                                          //   }
                                                                          // }
                                                                          // setState(
                                                                          //     () {});
                                                                          if (value! &&
                                                                              value) {
                                                                            if (selectedValuesIds[optionIndex] !=
                                                                                null) {
                                                                              if (!selectedValuesIds[optionIndex].contains(widget.product.options![optionIndex].values![index].productOptionValueId.toString())) {
                                                                                selectedValuesIds[optionIndex].add(widget.product.options![optionIndex].values![index].productOptionValueId.toString());
                                                                              }
                                                                            } else {
                                                                              selectedValuesIds[optionIndex] = [
                                                                                widget.product.options![optionIndex].values![index].productOptionValueId.toString()
                                                                              ];
                                                                            }
                                                                          } else {
                                                                            if (selectedValuesIds[optionIndex].contains(widget.product.options![optionIndex].values![index].productOptionValueId.toString())) {
                                                                              selectedValuesIds[optionIndex].remove(widget.product.options![optionIndex].values![index].productOptionValueId.toString());
                                                                            }
                                                                          }
                                                                          setState(
                                                                              () {});
                                                                          getPrice();
                                                                        },
                                                                      ),
                                                                    ),
                                                                  )
                                                                : Container(),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                        : Container(),
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                ),
                SizedBox(height: 10),
                BlocConsumer<CartBloc, CartState>(
                  listener: (ctx, state) {
                    if (state is CartFailed) {
                      showDialog(
                        context: context,
                        builder: (_) =>
                            // Directionality(
                            //   textDirection: TextDirection.rtl,
                            //   child:
                            AlertDialog(
                          content: Text(
                            state.message,
                            style: TextStyle(
                              fontFamily: 'GE',
                              fontSize: 14,
                            ),
                          ),
                          actions: [
                            PrimaryButton(
                              padding: 5,
                              textSize: 16,
                              textWeight: FontWeight.bold,
                              title: "تم",
                              onTap: () => Navigator.pop(context),
                            )
                          ],
                        ),
                        // ),
                      );
                    } else if (state is CartLoaded) {
                      if (state.updated != null && state.updated!) {
                        // Navigator.pop(ctx);
                        setState(() {
                          _addedToCart = true;
                        });
                      }
                    }
                  },
                  builder: (ctx, state) {
                    if (state is CartLoading) {
                      return LinearProgressIndicator();
                    }
                    return PrimaryButton(
                      padding: 5,
                      textSize: 16,
                      textWeight: FontWeight.bold,
                      title: tr('add to cart'),
                      // title: "أضف للسلة",
                      onTap: () {
                        if (widget.product.options!.length > 0) {
                          for (var i = 0; i < selectedValuesIds.length; i++) {
                            Map options = {};
                            for (var i = 0; i < selectedValuesIds.length; i++) {
                              options[widget.product.options![i].id
                                  .toString()] = selectedValuesIds[i];
                            }
                            BlocProvider.of<CartBloc>(context).add(
                              AddItem(
                                productId: widget.product.id,
                                quantity: qty,
                                option: options,
                              ),
                            );
                            // return Navigator.of(context).pop();
                            return null;
                          }
                        } else {
                          BlocProvider.of<CartBloc>(context).add(
                            AddItem(
                              productId: widget.product.id,
                              quantity: qty,
                            ),
                          );
                          // return Navigator.of(context).pop();
                          return null;
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          );
  }
}

// class SelectOptionSection extends StatefulWidget {
//   final Option option;
//   final List<int> initialValues;
//   final Function handler;
//   SelectOptionSection(this.option, this.initialValues, this.handler);

//   @override
//   _SelectOptionSectionState createState() => _SelectOptionSectionState();
// }

// class _SelectOptionSectionState extends State<SelectOptionSection>
//     with SingleTickerProviderStateMixin {
//   AnimationController controller;
//   Animation<double> scaleAnimation;

//   List<int> selectedOptionValues = [];
//   @override
//   void initState() {
//     if (widget.initialValues != null) {
//       selectedOptionValues = widget.initialValues;
//       if (selectedOptionValues.length > 0) {
//         for (var i = 0; i < selectedOptionValues.length; i++) {
//           if (selectedOptionValues[i] == null) {
//             selectedOptionValues.removeAt(i);
//           }
//         }
//       }
//     }

//     super.initState();
//     controller = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 500),
//     );
//     scaleAnimation = CurvedAnimation(parent: controller, curve: Curves.ease);

//     controller.addListener(() {
//       setState(() {});
//     });

//     controller.forward();
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Material(
//         color: Colors.transparent,
//         child: ScaleTransition(
//           scale: scaleAnimation,
//           child: ConstrainedBox(
//             constraints: BoxConstraints(maxWidth: 600),
//             child: Container(
//               margin: EdgeInsets.all(20),
//               decoration: ShapeDecoration(
//                 color: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15.0),
//                 ),
//               ),
//               child: Directionality(
//                 textDirection: TextDirection.rtl,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(10.0),
//                       child: Text(
//                         widget.option.name ?? '',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
//                     SingleChildScrollView(
//                       child: widget.option.type != null &&
//                               (widget.option.type == 'radio' ||
//                                   widget.option.type == 'select' ||
//                                   widget.option.type == 'checkbox')
//                           ? widget.option.type == 'select'
//                               ? Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 15),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text(
//                                         widget.option.name ?? '',
//                                       ),
//                                       DropdownButton<String>(
//                                         hint: Text(
//                                           'اختر',
//                                           style: TextStyle(
//                                             fontFamily: 'GE',
//                                           ),
//                                         ),
//                                         value: selectedOptionValues.length > 0
//                                             ? selectedOptionValues[0].toString()
//                                             : null,
//                                         style: TextStyle(
//                                           fontFamily: 'GE',
//                                         ),
//                                         onChanged: (value) {
//                                           setState(() {
//                                             selectedOptionValues = [
//                                               int.tryParse(value)
//                                             ];
//                                           });

//                                           final x =
//                                               widget.option.values.firstWhere(
//                                             (element) =>
//                                                 element.optionValueId ==
//                                                 int.tryParse(value),
//                                             orElse: () => null,
//                                           );
//                                           if (x != null) {
//                                             widget.handler([x]);
//                                           }
//                                         },
//                                         items: widget.option.values.map((x) {
//                                           return DropdownMenuItem(
//                                             value: x.optionValueId.toString(),
//                                             child: Text(
//                                               x.name ?? '',
//                                               style: TextStyle(
//                                                 fontFamily: 'GE',
//                                               ),
//                                             ),
//                                           );
//                                         }).toList(),
//                                       ),
//                                     ],
//                                   ),
//                                 )
//                               : Column(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: List.generate(
//                                     widget.option.values.length,
//                                     (index) => Container(
//                                       child: Row(
//                                         children: [
//                                           widget.option.type == 'radio'
//                                               ? Expanded(
//                                                   child: Container(
//                                                     child: RadioListTile(
//                                                       title: Text(widget
//                                                               .option
//                                                               .values[index]
//                                                               .name ??
//                                                           ''),
//                                                       value: widget
//                                                           .option
//                                                           .values[index]
//                                                           .optionValueId,
//                                                       groupValue:
//                                                           selectedOptionValues
//                                                                       .length >
//                                                                   0
//                                                               ? selectedOptionValues[
//                                                                   0]
//                                                               : '',
//                                                       onChanged: (value) {
//                                                         setState(() {
//                                                           selectedOptionValues =
//                                                               [value];
//                                                         });

//                                                         final x = widget
//                                                             .option.values
//                                                             .firstWhere(
//                                                           (element) =>
//                                                               element
//                                                                   .optionValueId ==
//                                                               value,
//                                                           orElse: () => null,
//                                                         );
//                                                         if (x != null) {
//                                                           widget.handler([x]);
//                                                         }
//                                                       },
//                                                       activeColor:
//                                                           Color(0xffa0b147),
//                                                     ),
//                                                   ),
//                                                 )
//                                               : widget.option.type == 'checkbox'
//                                                   ? Expanded(
//                                                       child: Container(
//                                                         child: CheckboxListTile(
//                                                           title: Text(widget
//                                                                   .option
//                                                                   .values[index]
//                                                                   .name ??
//                                                               ''),
//                                                           value:
//                                                               selectedOptionValues
//                                                                   .contains(
//                                                             widget
//                                                                 .option
//                                                                 .values[index]
//                                                                 .optionValueId,
//                                                           ),
//                                                           activeColor:
//                                                               Theme.of(context)
//                                                                   .primaryColor,
//                                                           onChanged: (value) {
//                                                             if (value) {
//                                                               if (!selectedOptionValues
//                                                                   .contains(widget
//                                                                       .option
//                                                                       .values[
//                                                                           index]
//                                                                       .optionValueId)) {
//                                                                 selectedOptionValues
//                                                                     .add(widget
//                                                                         .option
//                                                                         .values[
//                                                                             index]
//                                                                         .optionValueId);
//                                                               }
//                                                             } else {
//                                                               if (selectedOptionValues
//                                                                   .contains(widget
//                                                                       .option
//                                                                       .values[
//                                                                           index]
//                                                                       .optionValueId)) {
//                                                                 selectedOptionValues
//                                                                     .remove(widget
//                                                                         .option
//                                                                         .values[
//                                                                             index]
//                                                                         .optionValueId);
//                                                               }
//                                                             }
//                                                             setState(() {});

//                                                             List<OptionValue>
//                                                                 optionValues =
//                                                                 [];
//                                                             for (var i = 0;
//                                                                 i <
//                                                                     selectedOptionValues
//                                                                         .length;
//                                                                 i++) {
//                                                               optionValues.add(
//                                                                 widget.option
//                                                                     .values
//                                                                     .firstWhere(
//                                                                   (element) =>
//                                                                       element
//                                                                           .optionValueId ==
//                                                                       selectedOptionValues[
//                                                                           i],
//                                                                   orElse: () =>
//                                                                       null,
//                                                                 ),
//                                                               );
//                                                             }
//                                                             widget.handler(
//                                                                 optionValues);
//                                                           },
//                                                         ),
//                                                       ),
//                                                     )
//                                                   : Container(),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 )
//                           : Container(),
//                     ),
//                     SizedBox(height: 15),
//                     Center(
//                       child: PrimaryButton(
//                         padding: 8,
//                         textSize: 16,
//                         textWeight: FontWeight.bold,
//                         title: "تم",
//                         onTap: () {
//                           Navigator.pop(context);
//                         },
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
