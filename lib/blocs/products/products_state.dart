part of 'products_bloc.dart';

@immutable
abstract class ProductsState {}

class ProductsInitial extends ProductsState {}

class GettingProducts extends ProductsState {}

class GettingProductsDone extends ProductsState {
  final HomeProductsRes homeProducts;

  GettingProductsDone(this.homeProducts);
}

class GettingProductsFailed extends ProductsState {
  final String message;
  GettingProductsFailed(this.message);
}
