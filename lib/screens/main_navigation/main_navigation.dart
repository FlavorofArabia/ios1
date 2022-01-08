import 'package:easy_localization/easy_localization.dart';
import 'package:flavor/blocs/orders/orders_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../blocs/cart/cart_bloc.dart';
import '../../config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../screens.dart';

class MainNavigation extends StatefulWidget {
  final int? tabIndex;
  MainNavigation({this.tabIndex});
  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    HomeScreen(),
    CategoriesScreen(),
    CartScreen(),
    AccountScreen(),
    OrdersScreen(),
  ];

  @override
  void initState() {
    if (widget.tabIndex != null) {
      onTabTapped(widget.tabIndex!);
    }
    super.initState();
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex], // new
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 16,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.black54,
        // selectedLabelStyle: TextStyle(color: Theme.of(context).primaryColor),
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        type: BottomNavigationBarType.fixed,
        items: [
          new BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.home),
            // icon: Container(
            //   width: 25,
            //   height: 25,
            //   decoration: BoxDecoration(
            //     image: DecorationImage(
            //       image: AssetImage(
            //           _currentIndex == 0 ? Images.HomeActive : Images.Home),
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
            // label: 'الرئيسية',
            label: tr('home'),
          ),
          new BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.ship),
            // icon: Container(
            //   width: 25,
            //   height: 25,
            //   decoration: BoxDecoration(
            //     image: DecorationImage(
            //       image: AssetImage(_currentIndex == 1
            //           ? Images.CategoriesActive
            //           : Images.Categories),
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
            // label: 'الأقسام',
            label: tr('categories'),
          ),
          new BottomNavigationBarItem(
            // icon: Container(
            //   width: 25,
            //   height: 25,
            //   decoration: BoxDecoration(
            //     image: DecorationImage(
            //       image: AssetImage(
            //         _currentIndex == 2 ? Images.CartTabActive : Images.CartTab,
            //       ),
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
            icon: CartIcon(_currentIndex),
            // label: 'سلة الشراء',
            label: tr('cart'),
          ),
          new BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.user),
            // icon: Container(
            //   width: 25,
            //   height: 25,
            //   decoration: BoxDecoration(
            //     image: DecorationImage(
            //       image: AssetImage(_currentIndex == 3
            //           ? Images.ProfileTabActive
            //           : Images.ProfileTab),
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
            // label: 'حسابي',
            label: tr('account'),
          ),
          new BottomNavigationBarItem(
            icon: BlocBuilder<OrdersBloc, OrdersState>(
              builder: (context, state) {
                return FaIcon(FontAwesomeIcons.slidersH);
                // Container(
                //   width: 20,
                //   height: 20,
                //   decoration: BoxDecoration(
                //     image: DecorationImage(
                //       image: AssetImage(
                //         _currentIndex == 4
                //             ? Images.OrdersTabActive
                //             : Images.OrdersTab,
                //       ),
                //       fit: BoxFit.cover,
                //     ),
                //   ),
                // );
              },
            ),
            // label: 'الطلبات',
            label: tr('orders'),
          ),
        ],
      ),
    );
  }
}

class CartIcon extends StatelessWidget {
  final int index;
  CartIcon(this.index);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Align(
            alignment: Alignment(0, 0),
            child: FaIcon(FontAwesomeIcons.shoppingBasket)
            // Container(
            //   width: 25,
            //   height: 25,
            //   decoration: BoxDecoration(
            //     image: DecorationImage(
            //       image: AssetImage(
            //         index == 2 ? Images.CartTabActive : Images.CartTab,
            //       ),
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
            ),
        Align(
          alignment: Alignment(0.4, 0),
          child: BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartLoaded &&
                  state.parsedCart!.products != null &&
                  state.parsedCart!.products!.length > 0) {
                return Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Center(
                    child: Text(
                      '${state.parsedCart!.products!.length}',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Arial',
                      ),
                    ),
                  ),
                );
              }
              return Container();
            },
          ),
        ),
      ],
    );
  }
}
