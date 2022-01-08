import 'package:easy_localization/easy_localization.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/orders/orders_bloc.dart';
import '../../components/primary_button.dart';
import 'package:flutter/material.dart';

import '../../config/config.dart';
import '../../screens/orders/order_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8F8F6),
      appBar: AppBar(
        title: Text(
          // 'الطلبات السابقة',
          tr('orders'),
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
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: SingleChildScrollView(
                child: BlocBuilder<OrdersBloc, OrdersState>(
                  builder: (context, ordersState) {
                    if (ordersState is GettingOrdersDone) {
                      if (ordersState.orders.length > 0) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: List.generate(
                            ordersState.orders.length,
                            (index) => OrderItem(
                              ordersState.orders[index],
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('لا يوجد طلبات'),
                              SizedBox(height: 10),
                              PrimaryButton(
                                padding: 5,
                                height: 25,
                                textSize: 14,
                                textWeight: FontWeight.w300,
                                title: "اعد المحاولة",
                                onTap: () =>
                                    BlocProvider.of<OrdersBloc>(context).add(
                                  GetOrders(),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    } else if (ordersState is GettingOrders) {
                      return Container(
                        height: MediaQuery.of(context).size.height,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(Icons.refresh),
                              onPressed: () =>
                                  BlocProvider.of<OrdersBloc>(context).add(
                                GetOrders(),
                              ),
                            ),
                            SizedBox(height: 10),
                            PrimaryButton(
                              padding: 5,
                              height: 25,
                              textSize: 14,
                              textWeight: FontWeight.w300,
                              title: tr('refresh'),
                              // title: "اعد المحاولة",
                              onTap: () =>
                                  BlocProvider.of<OrdersBloc>(context).add(
                                GetOrders(),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'قم بتسجيل الدخول ',
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
                      title: 'تسجيل الدخول',
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
    );
  }
}

class SelectOptionSection extends StatefulWidget {
  final List<String> statuses;
  final String initialValue;
  final Function handler;
  SelectOptionSection(this.statuses, this.initialValue, this.handler);

  @override
  _SelectOptionSectionState createState() => _SelectOptionSectionState();
}

class _SelectOptionSectionState extends State<SelectOptionSection>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  late String selectedOptionValues;
  @override
  void initState() {
    if (widget.initialValue != null) {
      selectedOptionValues = widget.initialValue;
    }

    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    scaleAnimation = CurvedAnimation(parent: controller, curve: Curves.ease);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600),
            child: Container(
              margin: EdgeInsets.all(20),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              // child: Directionality(
              //   textDirection: TextDirection.rtl,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'التصنيف',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        widget.statuses.length,
                        (index) => Container(
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  child: RadioListTile(
                                    title: Text(widget.statuses[index]),
                                    value: widget.statuses[index],
                                    groupValue: selectedOptionValues.length > 0
                                        ? selectedOptionValues[0]
                                        : '',
                                    onChanged: (value) {
                                      setState(() {
                                        selectedOptionValues = value.toString();
                                      });

                                      widget.handler(value);
                                    },
                                    activeColor: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Center(
                    child: PrimaryButton(
                      padding: 8,
                      textSize: 16,
                      textWeight: FontWeight.bold,
                      title: "تم",
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              ),
              // ),
            ),
          ),
        ),
      ),
    );
  }
}
