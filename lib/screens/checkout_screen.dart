import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pos_provider.dart';
import '../widgets/kiosk_header.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  void _showPaymentPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const PaymentSimulationDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final posProvider = Provider.of<PosProvider>(context);
    final currencyFormat = NumberFormat.currency(symbol: 'IDR ', decimalDigits: 0, locale: 'id_ID');

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Column(
        children: [
          KioskHeader(
            title: 'Review Order',
            onBack: () => posProvider.setFlow(KioskFlow.menu),
            onNext: () => _showPaymentPopup(context),
            currentStep: 1,
          ),
          Expanded(
            child: Row(
              children: [
                // Left: Order Items Summary
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Order Items', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
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
                                          if (item.notes != null)
                                            Text(item.notes!, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
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
                
                // Right: Customer Details & Payment
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Customer Details', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 24),
                        const Text('Customer Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 8),
                        TextField(
                          onChanged: (v) => posProvider.customerName = v,
                          decoration: InputDecoration(
                            hintText: 'Enter your name',
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text('Table', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: posProvider.selectedTable,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          ),
                          items: ['Table 1', 'Table 2', 'Table 3', 'Takeaway']
                              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (v) => posProvider.selectedTable = v!,
                        ),
                        const SizedBox(height: 32),
                        const Text('Payment Method', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 24),
                        DropdownButtonFormField<String>(
                          value: posProvider.paymentMethod,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          ),
                          items: ['QRIS', 'Cash at Counter', 'Credit Card']
                              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (v) => posProvider.paymentMethod = v!,
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
                              _buildSummaryRow('Subtotal', currencyFormat.format(posProvider.subtotal)),
                              _buildSummaryRow('Tax', currencyFormat.format(posProvider.tax)),
                              const Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Total to Pay', style: TextStyle(fontSize: 16, color: Colors.grey)),
                                  Text(
                                    currencyFormat.format(posProvider.total),
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.blue,
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
                            onPressed: () => _showPaymentPopup(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
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
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class PaymentSimulationDialog extends StatefulWidget {
  const PaymentSimulationDialog({super.key});

  @override
  State<PaymentSimulationDialog> createState() => _PaymentSimulationDialogState();
}

class _PaymentSimulationDialogState extends State<PaymentSimulationDialog> {
  int _secondsLeft = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) {
        setState(() {
          _secondsLeft--;
        });
        // Condition: simulation of user paid at 00:46 remaining
        if (_secondsLeft == 46) {
          timer.cancel();
          _finishPayment();
        }
      } else {
        timer.cancel();
        _finishPayment();
      }
    });
  }

  void _finishPayment() {
    final posProvider = Provider.of<PosProvider>(context, listen: false);
    Navigator.pop(context);
    posProvider.setFlow(KioskFlow.confirmation);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final posProvider = Provider.of<PosProvider>(context);
    final currencyFormat = NumberFormat.currency(symbol: 'IDR ', decimalDigits: 0, locale: 'id_ID');

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      child: Container(
        padding: const EdgeInsets.all(40),
        width: 600,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Scan to Pay',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text(
              'Please complete the payment within the time limit',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200, width: 2),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Image.network(
                    'https://api.qrserver.com/v1/create-qr-code/?size=250x250&data=RMS-KIOSK-PAYMENT',
                    width: 250,
                    height: 250,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'QRIS',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.blue),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              currencyFormat.format(posProvider.total),
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.timer_outlined, color: Colors.red),
                const SizedBox(width: 8),
                Text(
                  '00:${_secondsLeft.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            const LinearProgressIndicator(),
            const SizedBox(height: 16),
            const Text(
              'Waiting for payment...',
              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
