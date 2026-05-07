import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final Color sheerColor;
  final Color solidColor;
  final List<Category>? subCategories;
  final String? parentId;

  Category({
    required this.id,
    required this.name,
    required this.sheerColor,
    required this.solidColor,
    this.subCategories,
    this.parentId,
  });

  static List<Category> get defaultCategories => [
    Category(
      id: 'all',
      name: 'All',
      sheerColor: const Color(0xFFE6F0FF),
      solidColor: const Color(0xFF006BFF),
    ),
    Category(
      id: 'appetizer',
      name: 'Appetizer',
      sheerColor: const Color(0xFFF9EB9E),
      solidColor: const Color(0xFFE3C106),
      subCategories: [
        Category(
          id: 'appetizer-1',
          name: 'Hot Starters',
          sheerColor: const Color(0xFFF9EB9E),
          solidColor: const Color(0xFFE3C106),
          parentId: 'appetizer',
        ),
        Category(
          id: 'appetizer-2',
          name: 'Cold Starters',
          sheerColor: const Color(0xFFF9EB9E),
          solidColor: const Color(0xFFE3C106),
          parentId: 'appetizer',
        ),
      ],
    ),
    Category(
      id: 'main-course',
      name: 'Main Course',
      sheerColor: const Color(0xFFD1C0F6),
      solidColor: const Color(0xFF511CC3),
      subCategories: [
        Category(
          id: 'main-burger',
          name: 'Burgers',
          sheerColor: const Color(0xFFD1C0F6),
          solidColor: const Color(0xFF511CC3),
          parentId: 'main-course',
          subCategories: [
            Category(
              id: 'main-burger-beef',
              name: 'Beef Burgers',
              sheerColor: const Color(0xFFD1C0F6),
              solidColor: const Color(0xFF511CC3),
              parentId: 'main-burger',
            ),
            Category(
              id: 'main-burger-chicken',
              name: 'Chicken Burgers',
              sheerColor: const Color(0xFFD1C0F6),
              solidColor: const Color(0xFF511CC3),
              parentId: 'main-burger',
            ),
          ],
        ),
        Category(
          id: 'main-pizza',
          name: 'Pizzas',
          sheerColor: const Color(0xFFD1C0F6),
          solidColor: const Color(0xFF511CC3),
          parentId: 'main-course',
        ),
      ],
    ),
    Category(
      id: 'desserts',
      name: 'Desserts',
      sheerColor: const Color(0xFFA5EEE6),
      solidColor: const Color(0xFF21AE9E),
    ),
    Category(
      id: 'beverages',
      name: 'Beverages',
      sheerColor: const Color(0xFFF5BCBC),
      solidColor: const Color(0xFFC01D1D),
    ),
  ];
}
