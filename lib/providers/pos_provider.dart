import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import '../models/order_item.dart';

class PosProvider with ChangeNotifier {
  final List<MenuItem> _menuItems = [
    MenuItem(
      id: '1',
      name: 'Classic Burger',
      description: 'Juicy beef patty with lettuce, tomato, and cheese.',
      price: 12.99,
      imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500',
      category: MenuCategory.mainCourse,
    ),
    MenuItem(
      id: '2',
      name: 'Margherita Pizza',
      description: 'Fresh basil, mozzarella, and tomato sauce.',
      price: 14.50,
      imageUrl: 'https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?w=500',
      category: MenuCategory.mainCourse,
    ),
    MenuItem(
      id: '3',
      name: 'Caesar Salad',
      description: 'Romaine lettuce, croutons, and parmesan cheese.',
      price: 9.99,
      imageUrl: 'https://images.unsplash.com/photo-1550304943-4f24f54ddde9?w=500',
      category: MenuCategory.appetizers,
    ),
    MenuItem(
      id: '4',
      name: 'Chocolate Lava Cake',
      description: 'Warm chocolate cake with a gooey center.',
      price: 7.50,
      imageUrl: 'https://images.unsplash.com/photo-1624353335558-98e7344933a3?w=500',
      category: MenuCategory.desserts,
    ),
    MenuItem(
      id: '5',
      name: 'Fresh Lemonade',
      description: 'Hand-squeezed lemons with a hint of mint.',
      price: 4.50,
      imageUrl: 'https://images.unsplash.com/photo-1534353436294-0dbd4bdac845?w=500',
      category: MenuCategory.beverages,
    ),
    MenuItem(
      id: '6',
      name: 'Truffle Fries',
      description: 'Crispy fries tossed in truffle oil and herbs.',
      price: 6.99,
      imageUrl: 'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=500',
      category: MenuCategory.appetizers,
    ),
  ];

  final List<OrderItem> _cart = [];
  MenuCategory _selectedCategory = MenuCategory.all;

  List<MenuItem> get menuItems => _selectedCategory == MenuCategory.all
      ? _menuItems
      : _menuItems.where((item) => item.category == _selectedCategory).toList();

  List<OrderItem> get cart => [..._cart];
  MenuCategory get selectedCategory => _selectedCategory;

  double get subtotal => _cart.fold(0, (sum, item) => sum + item.totalPrice);
  double get tax => subtotal * 0.1;
  double get total => subtotal + tax;

  void setCategory(MenuCategory category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void addToCart(MenuItem item) {
    final index = _cart.indexWhere((element) => element.item.id == item.id);
    if (index >= 0) {
      _cart[index].quantity++;
    } else {
      _cart.add(OrderItem(item: item));
    }
    notifyListeners();
  }

  void removeFromCart(String itemId) {
    _cart.removeWhere((element) => element.item.id == itemId);
    notifyListeners();
  }

  void updateQuantity(String itemId, int delta) {
    final index = _cart.indexWhere((element) => element.item.id == itemId);
    if (index >= 0) {
      _cart[index].quantity += delta;
      if (_cart[index].quantity <= 0) {
        _cart.removeAt(index);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }
}
