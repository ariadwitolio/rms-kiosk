import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pos_provider.dart';
import 'package:intl/intl.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final posProvider = Provider.of<PosProvider>(context);
    final currencyFormat = NumberFormat.currency(symbol: '\$');

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => posProvider.setFlow(KioskFlow.menu),
        ),
        title: const Text('Review Your Order', style: TextStyle(fontWeight: FontWeight.w900)),
        centerTitle: true,
      ),
      body: Row(
        children: [
          // Order Summary
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Order Summary', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 24),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: ListView.separated(
                        padding: const EdgeInsets.all(24),
                        itemCount: posProvider.cart.length,
                        separatorBuilder: (context, index) => const Divider(height: 40),
                        itemBuilder: (context, index) {
                          final item = posProvider.cart[index];
                          return Row(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  image: DecorationImage(
                                    image: NetworkImage(item.item.imageUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.item.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 4),
                                    Text('Quantity: ${item.quantity}', style: TextStyle(color: Colors.grey.shade600)),
                                  ],
                                ),
                              ),
                              Text(currencyFormat.format(item.totalPrice), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Payment Actions
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Payment Method', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 24),
                  _PaymentOption(
                    title: 'QR Payment',
                    subtitle: 'Scan with your banking app',
                    icon: Icons.qr_code_2_rounded,
                    isSelected: true,
                  ),
                  const SizedBox(height: 16),
                  _PaymentOption(
                    title: 'Credit / Debit Card',
                    subtitle: 'Insert or tap your card',
                    icon: Icons.credit_card_rounded,
                    isSelected: false,
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total to Pay', style: TextStyle(fontSize: 18, color: Colors.grey)),
                            Text(
                              currencyFormat.format(posProvider.total),
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 80,
                    child: ElevatedButton(
                      onPressed: () => posProvider.setFlow(KioskFlow.confirmation),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      ),
                      child: const Text('Pay Now', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;

  const _PaymentOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade200,
          width: 2,
        ),
        color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.05) : Colors.transparent,
      ),
      child: Row(
        children: [
          Icon(icon, size: 40, color: isSelected ? Theme.of(context).primaryColor : Colors.grey),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
              ],
            ),
          ),
          if (isSelected)
            Icon(Icons.check_circle_rounded, color: Theme.of(context).primaryColor),
        ],
      ),
    );
  }
}
