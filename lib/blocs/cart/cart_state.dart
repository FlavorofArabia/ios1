part of 'cart_bloc.dart';

@immutable
abstract class CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final Cart? parsedCart;
  final bool? updated;
  CartLoaded({this.parsedCart, this.updated});

  double get totalParsedPrice =>
      parsedCart!.products!.fold(0, (totalParsed, current) {
        return totalParsed + (current.totalRaw!);
      });

  // double get shippingParsed =>
  //     parsedCart.products.fold(0, (shippingParsed, currentItem) {
  //       if (currentItem.shippingCost == null) {
  //         return shippingParsed;
  //       }
  //       return shippingParsed + (currentItem.shippingCost);
  //     }) /
  //     parsedCart.products
  //         .where((element) => element.shippingCost != null)
  //         .toList()
  //         .length;
}

class CartFailed extends CartState {
  final String message;
  CartFailed(this.message);
}

class CartError extends CartState {}
