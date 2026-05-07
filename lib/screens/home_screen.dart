import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pos_provider.dart';
import 'welcome_screen.dart';
import 'tablet_dashboard.dart';
import 'checkout_screen.dart';
import 'confirmation_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final posProvider = Provider.of<PosProvider>(context);

    switch (posProvider.currentFlow) {
      case KioskFlow.welcome:
        return const WelcomeScreen();
      case KioskFlow.menu:
        return const Scaffold(body: TabletDashboard());
      case KioskFlow.checkout:
        return CheckoutScreen();
      case KioskFlow.confirmation:
        return OrderConfirmationScreen();
      default:
        return const WelcomeScreen();
    }
  }
}
