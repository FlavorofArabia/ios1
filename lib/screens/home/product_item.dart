import 'package:easy_localization/easy_localization.dart';
import 'package:flavor/components/secodary_button.dart';
import 'package:flavor/config/global.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/cart/cart_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../product_detail/product_detail_screen.dart';
import '../../models/product.dart';

class ProductItem extends StatelessWidget {
  final Product? product;
  final Function? auth;
  ProductItem({this.product, this.auth});

  @override
  Widget build(BuildContext context) {
    if (product != null) {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => ProductDetailScreen(
                product: product!,
              ),
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
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          padding: EdgeInsets.symmetric(horizontal: 4),
          width: MediaQuery.of(context).size.width / 2.5,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              new BoxShadow(
                color: Color(0xffe2e2e2),
                offset: new Offset(0.0, 0.0),
                blurRadius: 1.0,
                spreadRadius: 1.0,
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Column(
              children: [
                Stack(
                  children: [
                    Center(
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: CachedNetworkImage(
                            imageUrl: product!.image != null
                                ? product!.image!
                                : 'https://via.placeholder.com/350x150',
                            fit: BoxFit.cover,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Center(
                              child: CircularProgressIndicator(
                                value: downloadProgress.progress,
                              ),
                            ),
                            errorWidget: (context, url, error) => Center(
                              child: Center(
                                child: Icon(Icons.error),
                              ),
                            ),
                            fadeInCurve: Curves.easeInOut,
                            fadeInDuration: Duration(milliseconds: 500),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 5,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            product!.name!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            strutStyle: StrutStyle(
                              height: 1.5,
                              forceStrutHeight: true,
                            ),
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        SizedBox(height: 5),
                        product!.priceExcludingTaxFormated != '' &&
                                product!.priceFormated !=
                                    product!.priceExcludingTaxFormated
                            ? Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    product!.priceFormated!,
                                    style: TextStyle(
                                      height: 1.3,
                                      color: Colors.red,
                                      fontFamily: 'Arial',
                                    ),
                                  ),
                                  Text(
                                    product!.priceExcludingTaxFormated!,
                                    style: TextStyle(
                                      height: 1.3,
                                      decoration: TextDecoration.lineThrough,
                                      fontFamily: 'Arial',
                                    ),
                                  )
                                ],
                              )
                            : Text(
                                product!.priceFormated!,
                                style: TextStyle(
                                  height: 1.3,
                                  color: Colors.black54,
                                  fontFamily: 'Arial',
                                ),
                              ),
                        SizedBox(height: 10),
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, authState) {
                            return BlocBuilder<CartBloc, CartState>(
                              builder: (context, cartState) {
                                if (authState is Authenticated) {
                                  if (cartState is CartLoaded) {
                                    // final inCart =
                                    //     cartState.parsedCart.products?.firstWhere(
                                    //   (element) =>
                                    //       element.productId == product.id,
                                    //   orElse: () => null,
                                    // );
                                    // if (inCart != null) {
                                    //   return Container(
                                    //     width:
                                    //         MediaQuery.of(context).size.width,
                                    //     child: Row(
                                    //       mainAxisSize: MainAxisSize.max,
                                    //       children: <Widget>[
                                    //         GestureDetector(
                                    //           onTap: product.quantity >
                                    //                   inCart.quantity
                                    //               ? () {
                                    //                   BlocProvider.of<CartBloc>(
                                    //                           context)
                                    //                       .add(
                                    //                     AddItem(
                                    //                       productId: product.id,
                                    //                       quantity: 1,
                                    //                     ),
                                    //                   );
                                    //                 }
                                    //               : null,
                                    //           child: Container(
                                    //             height: 30,
                                    //             decoration: BoxDecoration(
                                    //               color: product.quantity >
                                    //                       inCart.quantity
                                    //                   ? Theme.of(context).primaryColor
                                    //                   : Colors.grey,
                                    //             ),
                                    //             padding: EdgeInsets.symmetric(
                                    //               horizontal: 5,
                                    //               vertical: 5,
                                    //             ),
                                    //             child: Center(
                                    //               child: Icon(
                                    //                 Icons.add,
                                    //                 size: 20,
                                    //                 color: product.quantity >
                                    //                         inCart.quantity
                                    //                     ? Colors.white
                                    //                     : Colors.white,
                                    //               ),
                                    //             ),
                                    //           ),
                                    //         ),
                                    //         Expanded(
                                    //           child: Container(
                                    //             height: 30,
                                    //             color: Color(0xffF8F9F2),
                                    //             child: Center(
                                    //               child: Text(
                                    //                 '${inCart.quantity}',
                                    //                 style: TextStyle(
                                    //                   fontSize: 20,
                                    //                   color: Theme.of(context).primaryColor,
                                    //                 ),
                                    //               ),
                                    //             ),
                                    //           ),
                                    //         ),
                                    //         GestureDetector(
                                    //           onTap: () {
                                    //             if (inCart.quantity > 1) {
                                    //               BlocProvider.of<CartBloc>(
                                    //                       context)
                                    //                   .add(
                                    //                 UpdateItem(
                                    //                   inCart.key,
                                    //                   inCart.quantity - 1,
                                    //                 ),
                                    //               );
                                    //             } else {
                                    //               BlocProvider.of<CartBloc>(
                                    //                       context)
                                    //                   .add(
                                    //                 DeleteItem(inCart.key),
                                    //               );
                                    //             }
                                    //           },
                                    //           child: Container(
                                    //             height: 30,
                                    //             decoration: BoxDecoration(
                                    //               color: Theme.of(context).primaryColor,
                                    //             ),
                                    //             padding: EdgeInsets.symmetric(
                                    //               horizontal: 5,
                                    //               vertical: 5,
                                    //             ),
                                    //             child: Center(
                                    //               child: Icon(
                                    //                 Icons.remove,
                                    //                 size: 20,
                                    //                 color: Colors.white,
                                    //               ),
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       ],
                                    //     ),
                                    //   );
                                    // } else {
                                    return SecondaryButton(
                                      borderSize: 1,
                                      onTap: () {
                                        product!.options!.length > 0
                                            ? Navigator.of(context).push(
                                                PageRouteBuilder(
                                                  pageBuilder: (_, __, ___) =>
                                                      ProductDetailScreen(
                                                    product: product!,
                                                    // similarProducts:
                                                    //     similarProducts ?? [],
                                                  ),
                                                  transitionDuration: Duration(
                                                      milliseconds: 500),
                                                  transitionsBuilder: (_,
                                                      Animation<double>
                                                          animation,
                                                      __,
                                                      Widget child) {
                                                    return Opacity(
                                                      opacity: animation.value,
                                                      child: child,
                                                    );
                                                  },
                                                ),
                                              )
                                            : BlocProvider.of<CartBloc>(context)
                                                .add(
                                                AddItem(
                                                  productId: product!.id,
                                                  quantity: 1,
                                                ),
                                              );
                                      },
                                      title: tr('add to cart'),
                                      // title: 'أضف للسلة',
                                      verticalPadding: 3,
                                      textSize: 14,
                                    );
                                    // }
                                  } else if (cartState is CartLoading) {
                                    return LinearProgressIndicator();
                                  } else {
                                    return SecondaryButton(
                                      borderSize: 1,
                                      verticalPadding: 3,
                                      textSize: 14,
                                      title: "اعد المحاولة",
                                      onTap: () =>
                                          BlocProvider.of<CartBloc>(context)
                                              .add(
                                        LoadCart(),
                                      ),
                                    );
                                  }
                                } else {
                                  return SecondaryButton(
                                    borderSize: 1,
                                    verticalPadding: 3,
                                    textSize: 14,
                                    title: tr('add to cart'),
                                    // title: "اضف للسلة",
                                    onTap: () {
                                      Globals.auth(context);
                                    },
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            new BoxShadow(
              color: Color(0xffe2e2e2),
              offset: new Offset(0.0, 0.0),
              blurRadius: 2.0,
              spreadRadius: 5.0,
            )
          ],
        ),
        child: Shimmer.fromColors(
          baseColor: Theme.of(context).hoverColor,
          highlightColor: Theme.of(context).highlightColor,
          child: Container(
            width: MediaQuery.of(context).size.width / 2.5,
            padding: EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  height: 130,
                  width: MediaQuery.of(context).size.width / 2.5,
                  color: Colors.white,
                ),
                SizedBox(height: 5),
                Container(
                  height: 10,
                  width: 50,
                  color: Colors.white,
                ),
                SizedBox(height: 5),
                Container(
                  height: 10,
                  width: 70,
                  color: Colors.white,
                ),
                SizedBox(height: 5),
                Container(
                  height: 10,
                  width: 40,
                  color: Colors.white,
                ),
                SizedBox(height: 5),
                Container(
                  height: 10,
                  width: 40,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
