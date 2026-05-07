import 'category.dart';

class ModifierOption {
  final String id;
  final String name;
  final double price;

  ModifierOption({
    required this.id,
    required this.name,
    required this.price,
  });
}

class Modifier {
  final String id;
  final String name;
  final bool isRequired;
  final List<ModifierOption> options;

  Modifier({
    required this.id,
    required this.name,
    required this.isRequired,
    required this.options,
  });
}

enum MenuCategory {
  all,
  appetizers,
  mainCourse,
  desserts,
  beverages,
}

class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String categoryId;
  final List<Modifier> modifiers;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.categoryId,
    this.modifiers = const [],
  });
}
