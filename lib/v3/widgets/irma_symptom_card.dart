import 'package:flutter/material.dart';
import '../theme/irma_theme.dart';

class IrmaSymptomCard extends StatelessWidget {
  final String title;
  final String? value;
  final IconData icon;
  final Color baseColor;
  final VoidCallback onTap;
  final bool isEmpty;

  const IrmaSymptomCard({
    super.key,
    required this.title,
    this.value,
    required this.icon,
    this.baseColor = IrmaTheme.menstrual,
    required this.onTap,
    this.isEmpty = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 345,
        height: 124,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16), // Gospel Padding 16
        decoration: BoxDecoration(
          color: IrmaTheme.pureWhite,
          borderRadius: BorderRadius.circular(IrmaTheme.radiusCardMedium), // Gospel Rule for Symptom Cards
          border: Border.all(color: IrmaTheme.borderLight),
          boxShadow: [
            BoxShadow(
              color: IrmaTheme.pureBlack.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            // ICON BOX
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: baseColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: baseColor, size: 28),
            ),
            const SizedBox(width: 20),

            // CONTENT
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: IrmaTheme.outfit.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: IrmaTheme.textMain,
                    ),
                  ),
                  const SizedBox(height: 1), // Tight Gospel spacing
                  Text(
                    isEmpty ? "Tap to log" : (value ?? ""),
                    style: IrmaTheme.inter.copyWith(
                      fontSize: 12,
                      color: isEmpty ? IrmaTheme.textSub : baseColor,
                      fontWeight: isEmpty ? FontWeight.w400 : FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // ACTION ICON
            Icon(
              isEmpty ? Icons.add_circle_outline : Icons.check_circle,
              color: isEmpty ? IrmaTheme.borderLight : baseColor,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
