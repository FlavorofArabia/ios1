part of 'products_bloc.dart';

@immutable
abstract class ProductsEvent {}

class GetProducts extends ProductsEvent {}

class LoadMore extends ProductsEvent {
  final List<Product> shuffledProducts;
  final int more;
  LoadMore(this.shuffledProducts, this.more);
}
