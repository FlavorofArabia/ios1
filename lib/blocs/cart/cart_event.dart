part of 'cart_bloc.dart';

@immutable
abstract class CartEvent {}

class LoadCart extends CartEvent {}

class AddItem extends CartEvent {
  final int? productId;
  final int? quantity;
  final option;
  AddItem({
    this.productId,
    this.quantity,
    this.option,
  });
}

class UpdateItem extends CartEvent {
  final int key;
  final int productId;
  final int quantity;
  final option;
  UpdateItem(
    this.key,
    this.productId,
    this.quantity, {
    this.option,
  });
}

class DeleteItem extends CartEvent {
  final int key;
  DeleteItem(this.key);
}
