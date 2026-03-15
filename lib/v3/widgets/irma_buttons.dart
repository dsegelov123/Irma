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
        width: 143, // EXACT Gospel Width
        height: 48, // EXACT Gospel Height
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: IrmaTheme.primaryGradient, // Gospel Orange-Purple
          borderRadius: BorderRadius.circular(IrmaTheme.radiusAction), // Gospel Rule for BTNS
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF7B61).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(IrmaTheme.pureWhite),
                ),
              )
            : Text(
                label,
                style: IrmaTheme.inter.copyWith(
                  color: IrmaTheme.pureWhite,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
