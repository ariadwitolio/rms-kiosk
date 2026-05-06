import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pos_provider.dart';
import 'dart:async';

class OrderConfirmationScreen extends StatefulWidget {
  const OrderConfirmationScreen({super.key});

  @override
  State<OrderConfirmationScreen> createState() => _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  int _secondsRemaining = 10;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Clear cart when reaching this screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PosProvider>(context, listen: false).clearCart();
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _goToWelcome();
      }
    });
  }

  void _goToWelcome() {
    _timer?.cancel();
    Provider.of<PosProvider>(context, listen: false).setFlow(KioskFlow.welcome);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                size: 120,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Payment Successful!',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 16),
            const Text(
              'Your order has been sent to the kitchen.',
              style: TextStyle(fontSize: 24, color: Colors.grey),
            ),
            const SizedBox(height: 60),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  const Text(
                    'Your Order Number',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '#1254',
                    style: TextStyle(fontSize: 64, fontWeight: FontWeight.w900, letterSpacing: 4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),
            const Text(
              'Please take your receipt below',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            TextButton(
              onPressed: _goToWelcome,
              child: Text(
                'Back to Home ($_secondsRemaining)',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
