import 'package:easy_localization/easy_localization.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './parsed_cart_item.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../screens/cart/checkout_screen.dart';
import '../../components/primary_button.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          // 'السلة',
          tr('cart'),
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
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState is Authenticated) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: _CartList(),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    // 'قم بتسجيل الدخول ',
                    tr('go login') + ' ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    height: 40,
                    child: PrimaryButton(
                      // title: 'تسجيل الدخول',
                      title: tr('login'),
                      padding: 8,
                      onTap: () {
                        return Globals.auth(context);
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            if (authState is Authenticated) {
              return _CartTotal();
            } else {
              return Container(
                height: 0,
              );
            }
          },
        ),
      ),
    );
  }
}

class _CartList extends StatelessWidget {
  // final Cart cart = Cart(
  //   products: [
  //     CartItemModel(
  //       name:
  //           'اسم المنتج هنا اسم المنتج هنا اسم المنتج هنا اسم المنتج هنا اسم المنتج هنا ',
  //       priceRaw: 240,
  //       quantity: 3,
  //     ),
  //     CartItemModel(
  //       name:
  //           'اسم المنتج هنا اسم المنتج هنا اسم المنتج هنا اسم المنتج هنا اسم المنتج هنا ',
  //       priceRaw: 240,
  //       quantity: 3,
  //     ),
  //   ],
  // );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state is CartLoading) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is CartLoaded) {
          return state.parsedCart!.products!.length > 0
              ? ListView.builder(
                  itemCount: state.parsedCart!.products!.length,
                  itemBuilder: (context, index) => ParsedCartItem(
                    state.parsedCart!.products![index],
                  ),
                )
              : Center(
                  child: Text(
                    // 'لا يوجد منتجات في السلة',
                    tr('no items in cart'),
                    style: TextStyle(fontSize: 16),
                  ),
                );
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Text('حدث خطأ!'),
              Text(tr('error')),

              SizedBox(height: 15),
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () => BlocProvider.of<CartBloc>(context).add(
                  LoadCart(),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class _CartTotal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // 'السعر الاجمالي',
                  tr('total cost'),
                  strutStyle: StrutStyle(height: 1),
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                BlocBuilder<CartBloc, CartState>(
                  builder: (context, state) {
                    if (state is CartLoaded) {
                      return Text(
                        // '${state.totalParsedPrice.toStringAsFixed(0)} ريال',
                        '${state.parsedCart!.total}',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        strutStyle: StrutStyle(height: 1),
                      );
                    }
                    return Container();
                  },
                ),
              ],
            ),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) {
                return BlocBuilder<CartBloc, CartState>(
                  builder: (context, state) {
                    if (state is CartLoaded) {
                      return PrimaryButton(
                        backColor: Theme.of(context).primaryColor,
                        padding: 10,
                        // title: 'الدفع',
                        title: tr('checkout'),
                        textWeight: FontWeight.w300,
                        onTap: () {
                          if (authState is Authenticated) {
                            if (state.parsedCart!.products!.length == 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  // content: Text('السلة فارغة'),
                                  content: Text(tr('no items in cart')),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder: (_, __, ___) => CheckoutScreen(),
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
                          } else {
                            Globals.auth(context);
                          }
                        },
                      );
                    }
                    return Container();
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
