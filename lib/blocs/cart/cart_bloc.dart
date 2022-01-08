import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../models/cart.dart';
import '../../api/restful_api/cart_api.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartLoading());

  @override
  Stream<CartState> mapEventToState(
    CartEvent event,
  ) async* {
    if (event is LoadCart) {
      yield* _mapLoadCartToState(event);
    } else if (event is AddItem) {
      yield* _mapAddItemToState(event);
    } else if (event is UpdateItem) {
      yield* _mapUpdateItemToState(event);
    } else if (event is DeleteItem) {
      yield* _mapDeleteItemToState(event);
    }
  }

  Stream<CartState> _mapLoadCartToState(LoadCart event) async* {
    yield CartLoading();
    try {
      Cart parsedCartList = Cart.fromMap({});
      final parsedCart = await CartApi.getCart();
      if (parsedCart != null &&
          parsedCart['data'] != null &&
          parsedCart['data'] is! List) {
        parsedCartList = Cart.fromMap(parsedCart['data']);
        yield CartLoaded(parsedCart: parsedCartList);
      } else if (parsedCart != null && parsedCart['data'] != null) {
        yield CartLoaded(parsedCart: parsedCartList);
      } else {
        yield CartError();
      }
    } catch (err) {
      print(err);
      yield CartError();
    }
  }

  Stream<CartState> _mapAddItemToState(AddItem event) async* {
    yield CartLoading();
    final currentState = state;
    if (currentState is CartLoaded) {
      try {
        final oldCart = currentState.parsedCart;

        Cart parsedCartList = Cart.fromMap({});
        final addItem = await CartApi.addItem({
          'product_id': event.productId,
          'quantity': event.quantity,
          'option': event.option ?? {},
        });

        if (addItem != null && addItem['data'] != null) {
          final parsedCart = await CartApi.getCart();

          parsedCartList = Cart.fromMap(parsedCart['data']);

          if (parsedCart != null && parsedCart['data'] != null) {
            yield CartLoaded(parsedCart: parsedCartList, updated: true);
          } else if (parsedCart != null && parsedCart['message'] != null) {
            yield CartFailed(parsedCart['message']);
            yield CartLoaded(parsedCart: parsedCartList);
          } else {
            yield CartError();
          }
        } else if (addItem != null && addItem['message'] != null) {
          yield CartFailed(addItem['message']);
          yield CartLoaded(parsedCart: oldCart);
        } else {
          yield CartError();
        }
      } catch (err) {
        print(err);
        yield CartError();
      }
    }
  }

  Stream<CartState> _mapUpdateItemToState(UpdateItem event) async* {
    yield CartLoading();
    final currentState = state;
    if (currentState is CartLoaded) {
      try {
        final oldCart = currentState.parsedCart;

        Cart parsedCartList = Cart.fromMap({});
        final updateItem = await CartApi.updateItemInCart({
          'key': event.key,
          'product_id': event.productId,
          'quantity': event.quantity,
          'option': event.option ?? {},
        });

        if (updateItem != null && updateItem['data'] != null) {
          final parsedCart = await CartApi.getCart();

          parsedCartList = Cart.fromMap(parsedCart['data']);

          if (parsedCart != null && parsedCart['data'] != null) {
            yield CartLoaded(parsedCart: parsedCartList, updated: true);
          } else if (parsedCart != null && parsedCart['message'] != null) {
            yield CartFailed(parsedCart['message']);
            yield CartLoaded(parsedCart: parsedCartList);
          } else {
            yield CartError();
          }
        } else if (updateItem != null && updateItem['message'] != null) {
          yield CartFailed(updateItem['message']);
          yield CartLoaded(parsedCart: oldCart);
        } else {
          yield CartError();
        }
      } catch (err) {
        print(err);
        yield CartError();
      }
    }
  }

  Stream<CartState> _mapDeleteItemToState(DeleteItem event) async* {
    yield CartLoading();
    final currentState = state;
    if (currentState is CartLoaded) {
      try {
        Cart parsedCartList = Cart.fromMap({});
        final deleteItem = await CartApi.deleteItem({
          'key': event.key,
        });
        if (deleteItem != null && deleteItem['data'] != null) {
          final parsedCart = await CartApi.getCart();
          if (parsedCart != null &&
              parsedCart['data'] != null &&
              parsedCart['data'] is! List<dynamic>) {
            parsedCartList = Cart.fromMap(parsedCart['data']);
          }
          yield CartLoaded(parsedCart: parsedCartList);
        } else {
          yield CartError();
        }
      } catch (err) {
        print(err);
        yield CartError();
      }
    }
  }
}
