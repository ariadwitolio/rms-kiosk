import 'menu_item.dart';

class OrderItem {
  final MenuItem item;
  int quantity;

  OrderItem({
    required this.item,
    this.quantity = 1,
  });

  double get totalPrice => item.price * quantity;
}
