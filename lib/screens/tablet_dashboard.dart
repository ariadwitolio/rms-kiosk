import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pos_provider.dart';
import '../widgets/menu_grid.dart';
import '../widgets/cart_panel.dart';
import '../widgets/category_bar.dart';
import '../models/menu_item.dart';

class TabletDashboard extends StatelessWidget {
  const TabletDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final posProvider = Provider.of<PosProvider>(context);
    
    return Row(
      children: [
        // Kiosk Category Rail (Vertical)
        Container(
          width: 120,
          color: Colors.white,
          child: Column(
            children: [
              const SizedBox(height: 24),
              // Back/Home Button
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () => posProvider.setFlow(KioskFlow.welcome),
                style: IconButton.styleFrom(
                  padding: const EdgeInsets.all(20),
                  backgroundColor: Colors.grey.shade100,
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: ListView.builder(
                  itemCount: MenuCategory.values.length,
                  itemBuilder: (context, index) {
                    final category = MenuCategory.values[index];
                    final isSelected = posProvider.selectedCategory == category;
                    return InkWell(
                      onTap: () => posProvider.setCategory(category),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
                        decoration: BoxDecoration(
                          border: isSelected 
                            ? Border(right: BorderSide(color: Theme.of(context).primaryColor, width: 4))
                            : null,
                          color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.05) : null,
                        ),
                        child: Column(
                          children: [
                            Icon(
                              _getCategoryIcon(category),
                              color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
                              size: 32,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _getCategoryName(category),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        
        const VerticalDivider(thickness: 1, width: 1),
        
        // Main Menu Area
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getCategoryName(posProvider.selectedCategory),
                      style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w900),
                    ),
                    const Text(
                      'Select your items to add to order',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const Expanded(child: MenuGrid()),
            ],
          ),
        ),
        
        const VerticalDivider(thickness: 1, width: 1),
        
        // Kiosk Cart Panel
        const Expanded(
          flex: 2,
          child: CartPanel(),
        ),
      ],
    );
  }

  IconData _getCategoryIcon(MenuCategory category) {
    switch (category) {
      case MenuCategory.all: return Icons.grid_view_rounded;
      case MenuCategory.appetizers: return Icons.restaurant_rounded;
      case MenuCategory.mainCourse: return Icons.lunch_dining_rounded;
      case MenuCategory.desserts: return Icons.icecream_rounded;
      case MenuCategory.beverages: return Icons.local_bar_rounded;
    }
  }

  String _getCategoryName(MenuCategory category) {
    switch (category) {
      case MenuCategory.all: return 'All Items';
      case MenuCategory.appetizers: return 'Appetizers';
      case MenuCategory.mainCourse: return 'Main Course';
      case MenuCategory.desserts: return 'Desserts';
      case MenuCategory.beverages: return 'Beverages';
    }
  }
}
