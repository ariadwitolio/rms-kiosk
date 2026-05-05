import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pos_provider.dart';
import '../models/menu_item.dart';

class CategoryBar extends StatelessWidget {
  const CategoryBar({super.key});

  @override
  Widget build(BuildContext context) {
    final posProvider = Provider.of<PosProvider>(context);

    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: MenuCategory.values.length,
        itemBuilder: (context, index) {
          final category = MenuCategory.values[index];
          final isSelected = posProvider.selectedCategory == category;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(_getCategoryName(category)),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  posProvider.setCategory(category);
                }
              },
              selectedColor: Theme.of(context).primaryColor,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }

  String _getCategoryName(MenuCategory category) {
    switch (category) {
      case MenuCategory.all: return 'All';
      case MenuCategory.appetizers: return 'Appetizers';
      case MenuCategory.mainCourse: return 'Main Course';
      case MenuCategory.desserts: return 'Desserts';
      case MenuCategory.beverages: return 'Beverages';
    }
  }
}
