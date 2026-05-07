import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pos_provider.dart';

class KioskHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBack;
  final VoidCallback? onNext;
  final int currentStep; // 0: Menu, 1: Review, 2: Payment

  const KioskHeader({
    super.key,
    required this.title,
    required this.onBack,
    this.onNext,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Stack(
        children: [
          // Navigation & Stepper in center
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // BACK BUTTON
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: onBack,
                  style: IconButton.styleFrom(
                    padding: const EdgeInsets.all(12),
                    backgroundColor: Colors.grey.shade50,
                  ),
                ),
                const SizedBox(width: 40),

                // STEPPER
                SizedBox(
                  width: 400,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStep(0, 'Menu', currentStep >= 0),
                      _buildDivider(currentStep > 0),
                      _buildStep(1, 'Review', currentStep >= 1),
                      _buildDivider(currentStep > 1),
                      _buildStep(2, 'Payment', currentStep >= 2),
                    ],
                  ),
                ),

                const SizedBox(width: 40),
                // NEXT BUTTON
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios_rounded),
                  onPressed: onNext,
                  style: IconButton.styleFrom(
                    padding: const EdgeInsets.all(12),
                    backgroundColor: onNext != null ? Colors.blue.shade50 : Colors.grey.shade50,
                    foregroundColor: onNext != null ? Colors.blue : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(int index, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive ? Colors.blue : Colors.grey.shade200,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '${index + 1}',
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? Colors.blue : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(bool isActive) {
    return Container(
      width: 60,
      height: 2,
      margin: const EdgeInsets.only(
        left: 8,
        right: 8,
        bottom: 20,
      ),
      color: isActive ? Colors.blue : Colors.grey.shade200,
    );
  }
}
