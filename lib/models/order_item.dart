import 'menu_item.dart';

class OrderItem {
  final MenuItem item;
  int quantity;
  String? notes;

  OrderItem({
    required this.item,
    this.quantity = 1,
    this.notes,
  });

  double get totalPrice => item.price * quantity;
}
