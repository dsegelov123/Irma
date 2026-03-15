import 'package:flutter/material.dart';
import '../theme/irma_theme.dart';

class IrmaFAQChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const IrmaFAQChip({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 345, // Strict Gospel Width
        height: 52, // Strict Gospel Height
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: IrmaTheme.pureWhite,
          borderRadius: BorderRadius.circular(IrmaTheme.radiusCard), // Strict 32px Pill Radius
          border: Border.all(color: IrmaTheme.borderLight),
          boxShadow: [
            BoxShadow(
              color: IrmaTheme.pureBlack.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: IrmaTheme.inter.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: IrmaTheme.textMain,
            ),
          ),
        ),
      ),
    );
  }
}
