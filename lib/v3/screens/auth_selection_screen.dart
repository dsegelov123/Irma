import 'package:flutter/material.dart';
import '../theme/irma_theme.dart';
import 'identity_screen.dart';
import 'auth_screen.dart';

import '../widgets/irma_text_field.dart';
import '../widgets/irma_buttons.dart';
class IrmaAuthSelectionScreen extends StatelessWidget {
  const IrmaAuthSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: IrmaTheme.pureWhite,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Text(
              "Start Your Journey",
              style: IrmaTheme.outfit.copyWith(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Join Irma for a healthier, more balanced lite.",
              textAlign: TextAlign.center,
              style: IrmaTheme.inter.copyWith(color: IrmaTheme.textSub),
            ),
            const Spacer(),
            
            // SIGN UP BUTTON (Gospel Rectified)
            IrmaPrimaryButton(
              label: "Create Account",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const IrmaAuthScreen(initialMode: AuthMode.signUp)),
                );
              },
            ),
            
            const SizedBox(height: 16),
            
            // LOGIN BUTTON (Gospel Rectified Secondary Placeholder)
            // For now using Container to match Secondary spec until IrmaSecondaryButton is added to component file
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const IrmaAuthScreen(initialMode: AuthMode.login)),
                );
              },
              child: Container(
                height: 40, // Gospel Height
                width: double.infinity,
                decoration: BoxDecoration(
                  color: IrmaTheme.pureWhite,
                  borderRadius: BorderRadius.circular(IrmaTheme.radiusAction),
                  border: Border.all(color: IrmaTheme.borderLight, width: 2),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Log In",
                  style: IrmaTheme.inter.copyWith(
                    color: IrmaTheme.textMain,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),
            
            // SOCIAL DIVIDER
            Row(
              children: [
                Expanded(child: Divider(color: IrmaTheme.borderLight)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text("Or continue with", style: IrmaTheme.inter.copyWith(color: IrmaTheme.textSub)),
                ),
                Expanded(child: Divider(color: IrmaTheme.borderLight)),
              ],
            ),
            
            const SizedBox(height: 32),

            // SOCIAL BUTTONS Placeholder
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSocialIcon(Icons.apple),
                const SizedBox(width: 20),
                _buildSocialIcon(Icons.g_mobiledata_rounded, size: 40),
              ],
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }


  Widget _buildSocialIcon(IconData icon, {double size = 30}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: IrmaTheme.borderLight),
      ),
      child: Icon(icon, color: IrmaTheme.textMain, size: size),
    );
  }
}
