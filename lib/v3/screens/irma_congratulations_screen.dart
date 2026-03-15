import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../theme/irma_theme.dart';

class IrmaCongratulationsScreen extends StatelessWidget {
  const IrmaCongratulationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: IrmaTheme.pureWhite,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SUCCESS ICON / ILLUSTRATION
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: IrmaTheme.follicular.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Iconsax.verify5,
                color: IrmaTheme.follicular,
                size: 80,
              ),
            ),
            const SizedBox(height: 40),
            Text(
              "Great Job!",
              style: IrmaTheme.outfit.copyWith(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: IrmaTheme.textMain,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "You've completed your guided\nself-care session. How do you feel?",
              textAlign: TextAlign.center,
              style: IrmaTheme.inter.copyWith(
                fontSize: 18,
                color: IrmaTheme.textSub,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 60),
            // PRIMARY ACTION (Return Home)
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                gradient: IrmaTheme.primaryGradient,
                borderRadius: BorderRadius.circular(IrmaTheme.radiusAction),
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(IrmaTheme.radiusAction),
                  ),
                ),
                child: Text(
                  "Return to Home",
                  style: IrmaTheme.outfit.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: IrmaTheme.pureWhite,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
