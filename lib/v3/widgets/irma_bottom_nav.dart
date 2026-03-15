import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:iconsax/iconsax.dart';
import '../theme/irma_theme.dart';

class IrmaBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const IrmaBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 248, // EXACT Gospel Dimension
      height: 64,
      margin: const EdgeInsets.only(bottom: 30),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: IrmaTheme.pureWhite.withOpacity(0.8),
        borderRadius: BorderRadius.circular(40), // Gospel Radius
        boxShadow: [
          BoxShadow(
            color: IrmaTheme.pureBlack.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: IrmaTheme.borderLight, width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildNavItem(0, Iconsax.home_2, "Cycle"),
              const SizedBox(width: 8),
              _buildCenterItem(),
              const SizedBox(width: 8),
              _buildNavItem(2, Iconsax.chart_2, "Insights"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = currentIndex == index;
    return Semantics(
      label: label,
      selected: isSelected,
      button: true,
      child: GestureDetector(
        onTap: () => onTap(index),
        child: Container(
          width: isSelected ? 77 : 64, // Gospel Variant Widths
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: isSelected ? IrmaTheme.menstrual : IrmaTheme.textSub,
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildCenterItem() {
    return Semantics(
      label: "Cycle Tracking",
      button: true,
      child: GestureDetector(
        onTap: () => onTap(1), // Index 1 is AI/Center
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            gradient: IrmaTheme.primaryGradient,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Iconsax.flash_1, // Cycle/Sync symbol
            color: IrmaTheme.pureWhite,
            size: 26,
          ),
        ),
      ),
    );
  }
}
