import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../theme/irma_theme.dart';
import '../widgets/irma_nav_bar.dart';
import '../widgets/irma_cards.dart';

class IrmaSupportScreen extends StatelessWidget {
  const IrmaSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const IrmaNavigationBar(title: 'Help & Support', showBackButton: true),
          Padding(
            padding: const EdgeInsets.only(top: 287), // Immersive header height
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(IrmaTheme.margin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionLabel("Resources"),
                  const SizedBox(height: 16),
                  IrmaProfileTile(
                    title: 'Frequently Asked Questions',
                    icon: Iconsax.message_question,
                    onTap: () {
                      // Placeholder for FAQ
                    },
                  ),
                  IrmaProfileTile(
                    title: 'Privacy Policy',
                    icon: Iconsax.document_text,
                    onTap: () {
                      // Placeholder for Privacy Policy
                    },
                  ),
                  IrmaProfileTile(
                    title: 'Terms of Service',
                    icon: Iconsax.document_copy,
                    onTap: () {
                      // Placeholder for Terms
                    },
                  ),
                  
                  const SizedBox(height: 32),
                  _buildSectionLabel("Contact Us"),
                  const SizedBox(height: 16),
                  IrmaProfileTile(
                    title: 'Contact Support',
                    icon: Iconsax.message_2,
                    onTap: () {
                      // Placeholder for Contact
                    },
                  ),
                  IrmaProfileTile(
                    title: 'Report a Bug',
                    icon: Iconsax.danger,
                    onTap: () {
                      // Placeholder for Bug Report
                    },
                  ),
                  
                  const SizedBox(height: 48),
                  Center(
                    child: Text(
                      'Irma v3.0.0',
                      style: IrmaTheme.inter.copyWith(
                        color: IrmaTheme.textSub,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        label.toUpperCase(),
        style: IrmaTheme.inter.copyWith(
          color: IrmaTheme.textSub,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
