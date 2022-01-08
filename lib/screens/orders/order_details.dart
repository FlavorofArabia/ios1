import 'package:easy_localization/easy_localization.dart';
import 'package:flavor/config/images.dart';

import '../../api/restful_api/order_api.dart';
import '../../models/order.dart';
import '../../screens/orders/order_item.dart';
import './product_item.dart';
import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatefulWidget {
  final int orderId;
  const OrderDetailsScreen(this.orderId);

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Order? order;
  getData() async {
    try {
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }
      final res = await OrderApi.getOrder(widget.orderId);
      if (res['data'] != null) {
        order = Order.fromMap(res['data']);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8F8F6),
      appBar: AppBar(
        title: Text(
          // 'تفاصيل الطلب',
          tr('order details'),
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
          // Directionality(
          //   textDirection: TextDirection.rtl,
          //   child:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        order != null ? OrderItem(order!) : Container(),
                        order!.products!.length > 0
                            ? Column(
                                children: List.generate(
                                  order!.products!.length,
                                  (index) =>
                                      ProductItem(order!.products![index]),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
      // ),
      bottomNavigationBar:
          // Directionality(
          //   textDirection: TextDirection.rtl,
          //   child:
          Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(
            //       'المنتجات',
            //       style: TextStyle(color: Colors.grey),
            //     ),
            //     Text(
            //       '240 ريال',
            //       style: TextStyle(color: Colors.grey),
            //     ),
            //   ],
            // ),
            // SizedBox(height: 10),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(
            //       'التوصيل',
            //       style: TextStyle(color: Colors.grey),
            //     ),
            //     Text(
            //       '240 ريال',
            //       style: TextStyle(color: Colors.grey),
            //     ),
            //   ],
            // ),
            // SizedBox(height: 10),
            // Divider(),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  // 'السعر الاجمالي',
                  tr('total cost'),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  order != null ? order!.total! : '',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10),
            // PrimaryButton(
            //   padding: 12,
            //   height: 25,
            //   textSize: 16,
            //   textWeight: FontWeight.bold,
            //   title: "اعادة الطلب",
            //   onTap: () {
            //     Navigator.pop(context);
            //   },
            // ),
          ],
        ),
      ),
      // ),
    );
  }
}
