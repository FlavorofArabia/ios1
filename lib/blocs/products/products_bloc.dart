import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../api/restful_api/product_api.dart';
import '../../models/product.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  ProductsBloc() : super(ProductsInitial());

  @override
  Stream<ProductsState> mapEventToState(
    ProductsEvent event,
  ) async* {
    if (event is GetProducts) {
      try {
        yield GettingProducts();
        final res = await ProductApi.getHomePageCategoryWithItProducts();
        if (res['data'] != null) {
          yield GettingProductsDone(HomeProductsRes.fromJson(res['data']));
        } else {
          yield GettingProductsFailed(res['message']);
        }
      } catch (err) {
        yield ProductsInitial();
      }
    }
  }
}
