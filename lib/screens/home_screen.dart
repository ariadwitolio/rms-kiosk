import 'package:flutter/material.dart';
import '../widgets/responsive_layout.dart';
import 'tablet_dashboard.dart';
import 'mobile_dashboard.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsiveLayout(
        mobile: MobileDashboard(),
        tablet: TabletDashboard(),
      ),
    );
  }
}
