import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pos_provider.dart';
import 'package:intl/intl.dart';

class CartPanel extends StatelessWidget {
  const CartPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final posProvider = Provider.of<PosProvider>(context);
    final currencyFormat = NumberFormat.currency(symbol: '\$');

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Your Order',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
              ),
              if (posProvider.cart.isNotEmpty)
                TextButton.icon(
                  onPressed: () => posProvider.clearCart(),
                  icon: const Icon(Icons.delete_outline_rounded, size: 20),
                  label: const Text('Clear'),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: posProvider.cart.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_basket_outlined, size: 80, color: Colors.grey.shade200),
                        const SizedBox(height: 16),
                        Text(
                          'Your cart is empty',
                          style: TextStyle(color: Colors.grey.shade400, fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add items from the menu',
                          style: TextStyle(color: Colors.grey.shade300, fontSize: 14),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    itemCount: posProvider.cart.length,
                    separatorBuilder: (context, index) => const Divider(height: 32),
                    itemBuilder: (context, index) {
                      final orderItem = posProvider.cart[index];
                      return Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  orderItem.item.name,
                                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  currencyFormat.format(orderItem.item.price),
                                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_rounded),
                                  onPressed: () => posProvider.updateQuantity(orderItem.item.id, -1),
                                  iconSize: 24,
                                  padding: const EdgeInsets.all(8),
                                ),
                                Text(
                                  '${orderItem.quantity}',
                                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_rounded),
                                  onPressed: () => posProvider.updateQuantity(orderItem.item.id, 1),
                                  iconSize: 24,
                                  padding: const EdgeInsets.all(8),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                _buildSummaryRow('Subtotal', currencyFormat.format(posProvider.subtotal)),
                _buildSummaryRow('Tax (10%)', currencyFormat.format(posProvider.tax)),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(),
                ),
                _buildSummaryRow(
                  'Total',
                  currencyFormat.format(posProvider.total),
                  isBold: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 80,
            child: ElevatedButton(
              onPressed: posProvider.cart.isEmpty ? null : () {
                posProvider.setFlow(KioskFlow.checkout);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Review & Checkout', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                  SizedBox(width: 12),
                  Icon(Icons.arrow_forward_rounded, size: 28),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 18 : 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 18 : 14,
            ),
          ),
        ],
      ),
    );
  }
}
