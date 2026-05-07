import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/pos_provider.dart';
import '../widgets/menu_grid.dart';
import '../widgets/cart_panel.dart';
import '../widgets/kiosk_header.dart';
import '../models/menu_item.dart';
import '../models/category.dart';

class TabletDashboard extends StatelessWidget {
  const TabletDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final posProvider = Provider.of<PosProvider>(context);

    return Column(
      children: [
        KioskHeader(
          title: 'RMS Kiosk',
          onBack: () => posProvider.setFlow(KioskFlow.welcome),
          onNext: posProvider.cart.isNotEmpty ? () => posProvider.setFlow(KioskFlow.checkout) : null,
          currentStep: 0,
        ),
        Expanded(
          child: Row(
            children: [
              // LEFT CATEGORY SIDEBAR
              Container(
                width: 200, // Increased width for better alignment
                color: Colors.white,
                child: Column(
                  children: [
                    // Nested Header (Back + Category Name)
                    if (posProvider.canGoBackCategory)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                              onPressed: () => posProvider.goBackCategory(),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                posProvider.selectedCategory.name,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),

                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          // "All [Category]" item when nested
                          if (posProvider.canGoBackCategory)
                            _buildCategoryItem(
                              context,
                              Category(
                                id: posProvider.selectedCategory.id,
                                name: 'All ${posProvider.selectedCategory.name}',
                                sheerColor: posProvider.selectedCategory.sheerColor,
                                solidColor: posProvider.selectedCategory.solidColor,
                              ),
                              isSelected: true, // It's currently selected if we are here?
                              onTap: () {}, // Already selected
                            ),

                          ...posProvider.currentCategoryPanel.map((category) {
                            final isSelected = posProvider.selectedCategory.id == category.id;
                            final hasSub = category.subCategories != null && category.subCategories!.isNotEmpty;

                            return _buildCategoryItem(
                              context,
                              category,
                              isSelected: isSelected,
                              hasChevron: hasSub,
                              onTap: () => posProvider.setCategory(category),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const VerticalDivider(thickness: 1, width: 1),

              // CENTER MENU AREA
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Bar Section
                    Container(
                      padding: const EdgeInsets.all(24),
                      color: Colors.grey.shade50,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10),
                          ],
                        ),
                        child: const TextField(
                          decoration: InputDecoration(
                            icon: Icon(Icons.search, color: Colors.grey),
                            hintText: 'Search Menu...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),

                    const Expanded(
                      child: MenuGrid(),
                    ),
                  ],
                ),
              ),

              const VerticalDivider(thickness: 1, width: 1),

              // RIGHT CART PANEL
              const Expanded(
                flex: 2,
                child: CartPanel(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(
    BuildContext context,
    Category category, {
    required bool isSelected,
    bool hasChevron = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: category.sheerColor,
          border: isSelected
              ? Border(
                  left: BorderSide(
                    color: category.solidColor,
                    width: 6,
                  ),
                )
              : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                category.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected ? category.solidColor : Colors.black87,
                ),
              ),
            ),
            if (hasChevron)
              Icon(Icons.chevron_right_rounded, color: isSelected ? category.solidColor : Colors.grey),
          ],
        ),
      ),
    );
  }
}