part of 'orders_bloc.dart';

@immutable
abstract class OrdersState {}

class OrdersInitial extends OrdersState {}

class GettingOrders extends OrdersState {}

class GettingOrdersDone extends OrdersState {
  final List<Order> orders;
  final OrdersRes parsedOrders;
  GettingOrdersDone(this.orders, this.parsedOrders);
}

class GettingOrdersFailed extends OrdersState {
  final String message;
  GettingOrdersFailed(this.message);
}
