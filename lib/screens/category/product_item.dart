import 'package:easy_localization/easy_localization.dart';
import 'package:flavor/components/secodary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../config/config.dart';
import '../../components/primary_button.dart';
import '../../models/product.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../screens/product_detail/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  final Product? product;
  // final List<Product> similarProducts;
  ProductItem({
    this.product,
    // this.similarProducts,
  });

  @override
  Widget build(BuildContext context) {
    if (product != null) {
      return
          // Directionality(
          //   textDirection: TextDirection.rtl,
          //   child:
          GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => ProductDetailScreen(
                product: product!,
                // similarProducts: similarProducts ?? [],
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
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Color(0xffe2e2e2)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Wrap(
              children: [
                Center(
                  child: Container(
                    height: 140,
                    width: MediaQuery.of(context).size.width,
                    child: CachedNetworkImage(
                      imageUrl: product!.image != null ? product!.image! : '',
                      fit: BoxFit.fill,
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
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Text(
                          product!.name!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          strutStyle: StrutStyle(
                            forceStrutHeight: true,
                          ),
                          style: TextStyle(
                            height: 1.4,
                            fontSize: 16,
                            letterSpacing: 0.5,
                            color: Color(0xff55311B),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      product!.priceExcludingTaxFormated != '' &&
                              product!.priceFormated !=
                                  product!.priceExcludingTaxFormated
                          ? Row(
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
                            builder: (context, state) {
                              if (authState is Authenticated) {
                                if (state is CartLoaded) {
                                  // final inCart =
                                  //     state.parsedCart.products?.firstWhere(
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
                                    onTap: () {
                                      product!.options!.length > 0
                                          ? Navigator.of(context).push(
                                              PageRouteBuilder(
                                                pageBuilder: (_, __, ___) =>
                                                    ProductDetailScreen(
                                                  product: product!,
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
                                    borderSize: 1,
                                  );
                                  // }
                                } else if (state is CartLoading) {
                                  return LinearProgressIndicator();
                                }
                                return SecondaryButton(
                                  verticalPadding: 3,
                                  textSize: 14,
                                  borderSize: 1,
                                  title: "اعد المحاولة",
                                  onTap: () =>
                                      BlocProvider.of<CartBloc>(context).add(
                                    LoadCart(),
                                  ),
                                );
                              } else {
                                return SecondaryButton(
                                  verticalPadding: 3,
                                  textSize: 14,
                                  borderSize: 1,
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
              ],
            ),
          ),
        ),
        // ),
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
        child: Column(
          children: <Widget>[
            Container(
              height: 130,
              width: double.infinity,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            Shimmer.fromColors(
              baseColor: Theme.of(context).hoverColor,
              highlightColor: Theme.of(context).highlightColor,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(5),
                child: Column(
                  children: <Widget>[
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
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Color(0xffe2e2e2)),
                        ),
                      ),
                      child: LinearProgressIndicator(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
