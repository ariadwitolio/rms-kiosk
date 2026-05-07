import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import '../models/order_item.dart';
import '../models/category.dart';

enum KioskFlow { welcome, menu, checkout, confirmation }

class PosProvider with ChangeNotifier {
  KioskFlow _currentFlow = KioskFlow.welcome;
  KioskFlow get currentFlow => _currentFlow;

  void setFlow(KioskFlow flow) {
    _currentFlow = flow;
    notifyListeners();
  }
  
  final List<MenuItem> _menuItems = [
    MenuItem(
      id: '1',
      name: 'Classic Burger',
      description: 'Juicy beef patty with lettuce, tomato, and cheese.',
      price: 12.99,
      imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500',
      categoryId: 'main-burger-beef',
      modifiers: [
        Modifier(
          id: 'm1',
          name: 'Extra Toppings',
          isRequired: false,
          options: [
            ModifierOption(id: 'o1', name: 'Extra Cheese', price: 1.50),
            ModifierOption(id: 'o2', name: 'Bacon', price: 2.00),
          ],
        ),
        Modifier(
          id: 'm2',
          name: 'Doneness',
          isRequired: true,
          options: [
            ModifierOption(id: 'o3', name: 'Medium Rare', price: 0.00),
            ModifierOption(id: 'o4', name: 'Medium', price: 0.00),
            ModifierOption(id: 'o5', name: 'Well Done', price: 0.00),
          ],
        ),
      ],
    ),
    MenuItem(
      id: '2',
      name: 'Margherita Pizza',
      description: 'Fresh basil, mozzarella, and tomato sauce.',
      price: 14.50,
      imageUrl: 'https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?w=500',
      categoryId: 'main-pizza',
    ),
    MenuItem(
      id: '3',
      name: 'Caesar Salad',
      description: 'Romaine lettuce, croutons, and parmesan cheese.',
      price: 9.99,
      imageUrl: 'https://images.unsplash.com/photo-1550304943-4f24f54ddde9?w=500',
      categoryId: 'appetizer-2',
    ),
    MenuItem(
      id: '4',
      name: 'Chocolate Lava Cake',
      description: 'Warm chocolate cake with a gooey center.',
      price: 7.50,
      imageUrl: 'https://images.unsplash.com/photo-1624353335558-98e7344933a3?w=500',
      categoryId: 'desserts',
    ),
    MenuItem(
      id: '5',
      name: 'Fresh Lemonade',
      description: 'Hand-squeezed lemons with a hint of mint.',
      price: 4.50,
      imageUrl: 'https://images.unsplash.com/photo-1534353436294-0dbd4bdac845?w=500',
      categoryId: 'beverages',
    ),
    MenuItem(
      id: '6',
      name: 'Truffle Fries',
      description: 'Crispy fries tossed in truffle oil and herbs.',
      price: 6.99,
      imageUrl: 'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=500',
      categoryId: 'appetizer-1',
    ),
  ];

  final List<OrderItem> _cart = [];
  
  // Category Navigation State
  final List<Category> _allCategories = Category.defaultCategories;
  Category _selectedCategory = Category.defaultCategories[0]; // 'All'
  List<Category> _currentCategoryPanel = Category.defaultCategories;
  final List<List<Category>> _navigationHistory = [];

  List<MenuItem> get menuItems {
    if (_selectedCategory.id == 'all') {
      return _menuItems;
    }
    // Recursive check for items in subcategories
    return _menuItems.where((item) => _isItemInCategory(item, _selectedCategory)).toList();
  }

  bool _isItemInCategory(MenuItem item, Category category) {
    if (item.categoryId == category.id) return true;
    if (category.subCategories != null) {
      return category.subCategories!.any((sub) => _isItemInCategory(item, sub));
    }
    return false;
  }

  List<OrderItem> get cart => [..._cart];
  Category get selectedCategory => _selectedCategory;
  List<Category> get currentCategoryPanel => _currentCategoryPanel;
  bool get canGoBackCategory => _navigationHistory.isNotEmpty;

  double get subtotal => _cart.fold(0, (sum, item) => sum + item.totalPrice);
  double get tax => subtotal * 0.05;
  double get serviceCharge => subtotal * 0.10;
  double get total => subtotal + tax + serviceCharge;

  // Fields for Checkout
  String customerName = '';
  String selectedTable = 'Table 1';
  String paymentMethod = 'QRIS';

  void setCategory(Category category) {
    _selectedCategory = category;
    
    // If it has subcategories, drill down
    if (category.subCategories != null && category.subCategories!.isNotEmpty) {
      _navigationHistory.add(_currentCategoryPanel);
      _currentCategoryPanel = category.subCategories!;
    }
    
    notifyListeners();
  }

  void goBackCategory() {
    if (_navigationHistory.isNotEmpty) {
      _currentCategoryPanel = _navigationHistory.removeLast();
      // If we go back, we might want to reset the selected category to the parent or keep it?
      // Usually, clicking back just changes the panel view.
      notifyListeners();
    }
  }

  void addToCart(MenuItem item, {int quantity = 1, String? notes}) {
    final index = _cart.indexWhere((element) => element.item.id == item.id && element.notes == notes);
    if (index >= 0) {
      _cart[index].quantity += quantity;
    } else {
      _cart.add(OrderItem(item: item, quantity: quantity, notes: notes));
    }
    notifyListeners();
  }

  void removeFromCart(String itemId) {
    _cart.removeWhere((element) => element.item.id == itemId);
    notifyListeners();
  }

  void updateQuantity(int index, int delta) {
    if (index >= 0 && index < _cart.length) {
      _cart[index].quantity += delta;
      if (_cart[index].quantity <= 0) {
        _cart.removeAt(index);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _cart.clear();
    customerName = '';
    selectedTable = 'Table 1';
    paymentMethod = 'QRIS';
    notifyListeners();
  }

  // Find root category for an item to get its color
  Category getRootCategory(String categoryId) {
    Category? findIn(List<Category> categories, String id) {
      for (var cat in categories) {
        if (cat.id == id) return cat;
        if (cat.subCategories != null) {
          var found = findIn(cat.subCategories!, id);
          if (found != null) return cat; // Return the top-level parent in this recursive search for "root"
        }
      }
      return null;
    }

    // Actually, I want the top-level category color.
    for (var root in _allCategories) {
      if (_isCategoryIdInCategory(categoryId, root)) {
        return root;
      }
    }
    return _allCategories[0]; // Default to 'All'
  }

  bool _isCategoryIdInCategory(String targetId, Category category) {
    if (category.id == targetId) return true;
    if (category.subCategories != null) {
      return category.subCategories!.any((sub) => _isCategoryIdInCategory(targetId, sub));
    }
    return false;
  }
}
