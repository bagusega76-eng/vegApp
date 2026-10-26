import 'vegetable_model.dart';

class CartItemModel {
  final VegetableModel vegetable;
  int quantity;

  CartItemModel({
    required this.vegetable,
    this.quantity = 1,
  });

  double get totalPrice => vegetable.price * quantity;
}
