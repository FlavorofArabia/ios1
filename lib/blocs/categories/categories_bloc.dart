import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../api/restful_api/category_api.dart';
import '../../models/category.dart';

part 'categories_event.dart';
part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  CategoriesBloc() : super(CategoriesInitial());

  @override
  Stream<CategoriesState> mapEventToState(
    CategoriesEvent event,
  ) async* {
    if (event is GetCategories) {
      try {
        yield GettingCategories();
        final List<Category> categories = [];
        final res = await CategoryApi.categoriesOneLevel();
        if (res['data'] != null) {
          for (var i = 0; i < res['data'].length; i++) {
            categories.add(Category.fromMap(res['data'][i]));
          }

          yield GettingCategoriesDone(categories);
        } else {
          yield GettingCategoriesFailed(res['message']);
        }
      } catch (err) {
        print(err);
        yield CategoriesInitial();
        yield GettingCategoriesFailed('Failed to load categories');
      }
    }
  }
}
