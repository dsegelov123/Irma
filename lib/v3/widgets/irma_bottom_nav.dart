import 'package:flutter/material.dart';
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
      width: 280, // Slightly wider to ensure icons have room on all screen sizes
      height: 64,
      margin: const EdgeInsets.only(bottom: 30), // Float it above the bottom edge
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: IrmaTheme.pureWhite,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: IrmaTheme.pureBlack.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: IrmaTheme.borderLight, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Iconsax.home_2),
          _buildNavItem(1, Iconsax.people),
          _buildCenterItem(),
          _buildNavItem(3, Iconsax.message_text),
          _buildNavItem(4, Iconsax.book),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon) {
    final isSelected = currentIndex == index;
    final labels = ["Home", "Community", "Cycle", "Chat", "Insights"];
    return Semantics(
      label: labels[index],
      selected: isSelected,
      button: true,
      child: GestureDetector(
        onTap: () => onTap(index),
        child: Icon(
          icon,
          color: isSelected ? IrmaTheme.menstrual : IrmaTheme.textSub,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildCenterItem() {
    return Semantics(
      label: "Cycle Tracking",
      button: true,
      child: GestureDetector(
        onTap: () => onTap(2),
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
