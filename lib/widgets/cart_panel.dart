import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pos_provider.dart';
import 'package:intl/intl.dart';
import 'product_detail_dialog.dart';

class CartPanel extends StatelessWidget {
  const CartPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final posProvider = Provider.of<PosProvider>(context);
    final currencyFormat = NumberFormat.currency(symbol: 'IDR ', decimalDigits: 0, locale: 'id_ID');

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Header of Cart: Order List & Clear
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Order List',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () => posProvider.clearCart(),
                  child: const Text('Clear', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ),

          // Item List
          Expanded(
            child: posProvider.cart.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_basket_outlined, size: 64, color: Colors.grey.shade100),
                        const SizedBox(height: 16),
                        Text('No items in order', style: TextStyle(color: Colors.grey.shade300)),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: posProvider.cart.length,
                    itemBuilder: (context, index) {
                      final orderItem = posProvider.cart[index];
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey.shade50)),
                        ),
                        child: Row(
                          children: [
                            // Blue vertical indicator
                            Container(width: 4, height: 60, color: Colors.blue),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    orderItem.item.name,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  if (orderItem.notes != null)
                                    Text(
                                      orderItem.notes!,
                                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  const SizedBox(height: 4),
                                  Text(
                                    currencyFormat.format(orderItem.item.price),
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            // Action Buttons
                            Row(
                              children: [
                                if (orderItem.quantity == 1)
                                  Container(
                                    margin: const EdgeInsets.only(right: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                                      onPressed: () => posProvider.removeFromCart(orderItem.item.id),
                                    ),
                                  )
                                else
                                  Container(
                                    margin: const EdgeInsets.only(right: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(Icons.remove, color: Colors.white, size: 20),
                                      onPressed: () => posProvider.updateQuantity(index, -1),
                                    ),
                                  ),
                                
                                Text(
                                  '${orderItem.quantity}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                
                                Container(
                                  margin: const EdgeInsets.only(left: 12, right: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.add, color: Colors.white, size: 20),
                                    onPressed: () => posProvider.updateQuantity(index, 1),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),

          // Summary Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Column(
              children: [
                _buildSummaryRow('Subtotal', currencyFormat.format(posProvider.subtotal)),
                _buildSummaryRow('Tax (5%)', currencyFormat.format(posProvider.tax)),
                _buildSummaryRow('Service Charge (10%)', currencyFormat.format(posProvider.serviceCharge)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Grand Total',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      currencyFormat.format(posProvider.total),
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 22, color: Colors.blue),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Bottom Action Button: Single "Continue"
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: posProvider.cart.isEmpty ? null : () {
                  posProvider.setFlow(KioskFlow.checkout);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Continue', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Text(value, style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
