import '../../models/product.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProductItem extends StatefulWidget {
  final Product item;
  ProductItem(this.item);

  @override
  _ParsedCartItemState createState() => _ParsedCartItemState();
}

class _ParsedCartItemState extends State<ProductItem> {
  final imageHeight = 70.0;

  final imageWidth = 70.0;

  final imageRadius = 8.0;

  navigateToProduct(productId) async {
    try {
      // final res = await ProductApi.getOne(productId);

      // if (res['data'] != null) {
      //   Product product = Product.fromMap(res['data']);
      //   Navigator.of(context).pushNamed(
      //     Routes.productDetail,
      //     arguments: {'product': product},
      //   );
      // } else {
      //   Flushbar(
      //     message: res['message'],
      //     backgroundColor: Colors.red,
      //     isDismissible: true,
      //     duration: Duration(milliseconds: 2000),
      //   )..show(context);
      // }
    } catch (err) {
      // print(err);
      // Flushbar(
      //   message: err.toString(),
      //   isDismissible: true,
      //   duration: Duration(milliseconds: 2000),
      // )..show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Container(
                width: imageWidth,
                height: imageHeight,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xffe2e2e2)),
                  borderRadius: BorderRadius.circular(imageRadius),
                  boxShadow: [
                    new BoxShadow(
                      color: Color(0xffe2e2e2),
                      offset: new Offset(0.0, 0.0),
                      blurRadius: 2.0,
                      spreadRadius: 1.0,
                    )
                  ],
                ),
                child: CachedNetworkImage(
                  imageUrl: widget.item.image != null ? widget.item.image! : '',
                  fit: BoxFit.fill,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
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
                        widget.item.name!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        widget.item.price.toString(),
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontFamily: 'Arial',
                        ),
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
              Expanded(
                child: Row(
                  children: [
                    Text('الكمية'),
                    Expanded(
                      child: Center(
                        child: Text(
                          widget.item.quantity.toString(),
                          style: TextStyle(
                            fontFamily: 'Arial',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Text('الاجمالي'),
                    Expanded(
                      child: Center(
                        child: Text(
                          widget.item.total ?? '',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
