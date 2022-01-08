part of 'categories_bloc.dart';

@immutable
abstract class CategoriesState {}

class CategoriesInitial extends CategoriesState {}

class GettingCategories extends CategoriesState {}

class GettingCategoriesDone extends CategoriesState {
  final List<Category> categories;
  GettingCategoriesDone(this.categories);
}

class GettingCategoriesFailed extends CategoriesState {
  final String message;
  GettingCategoriesFailed(this.message);
}
