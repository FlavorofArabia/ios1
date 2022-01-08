import 'package:easy_localization/easy_localization.dart';

import '../../config/config.dart';
import '../../models/order.dart';
import '../../screens/orders/order_details.dart';
import 'package:flutter/material.dart';

class OrderItem extends StatelessWidget {
  final Order order;
  const OrderItem(this.order);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => OrderDetailsScreen(order.id!),
            transitionDuration: Duration(milliseconds: 500),
            transitionsBuilder: (
              _,
              Animation<double> animation,
              __,
              Widget child,
            ) {
              return Opacity(
                opacity: animation.value,
                child: child,
              );
            },
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${tr('order')} #${order.id}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(order.total ?? ''),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    color: order.status == 'معلق'
                        ? Colors.red
                        : order.status == 'مكتمل'
                            ? Colors.green
                            : Color(0xffFFB43D),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    order.status ?? '',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    color: Color(0xffF8F9F2),
                    child: Row(
                      children: [
                        Image.asset(Images.Truck),
                        SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            order.dateAdded ?? '',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
