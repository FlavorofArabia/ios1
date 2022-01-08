import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../api/restful_api/order_api.dart';
import '../../models/order.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc() : super(OrdersInitial());

  @override
  Stream<OrdersState> mapEventToState(
    OrdersEvent event,
  ) async* {
    if (event is GetOrders) {
      try {
        yield GettingOrders();
        final List<Order> orders = [];
        final res = await OrderApi.getOrders();
        if (res['data'] != null) {
          if (res['data'] is Iterable) {
            for (var i = 0; i < res['data'].length; i++) {
              orders.add(Order.fromMap(res['data'][i]));
            }

            yield GettingOrdersDone(orders, OrdersRes());
          } else {
            yield GettingOrdersFailed('');
          }
        } else {
          yield GettingOrdersFailed(res['message']);
        }
      } catch (err) {
        print(err);
        yield OrdersInitial();
        yield GettingOrdersFailed('Failed to load orders');
      }
    }
  }
}
