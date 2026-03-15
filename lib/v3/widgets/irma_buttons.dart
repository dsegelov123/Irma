import 'package:flutter/material.dart';
import '../theme/irma_theme.dart';

class IrmaPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isLoading;

  const IrmaPrimaryButton({
    super.key,
    required this.label,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: double.infinity,
        height: 40, // EXACT Gospel Height (Rectified from 48)
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8), // EXACT Gospel Padding
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: IrmaTheme.primaryGradient,
          borderRadius: BorderRadius.circular(IrmaTheme.radiusAction),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF5E76).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isLoading)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(IrmaTheme.pureWhite),
                ),
              )
            else ...[
              // Placeholder for potential Icon (Gap 4 logic)
              Text(
                label,
                style: IrmaTheme.inter.copyWith(
                  color: IrmaTheme.pureWhite,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
