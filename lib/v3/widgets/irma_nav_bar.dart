import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../theme/irma_theme.dart';
import '../screens/settings_screen.dart';

class IrmaNavigationBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;

  const IrmaNavigationBar({
    super.key,
    this.title = "Irma",
    this.showBackButton = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(287);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 287,
      decoration: const BoxDecoration(
        gradient: IrmaTheme.headerGradient,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(43.7),
          topRight: Radius.circular(43.7),
        ),
      ),
      child: Stack(
        children: [
          // Background "Waves" or blobs can be added here as SVG/Images
          Positioned(
            top: 65,
            left: 24,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // LOGO SECTION
                Row(
                  children: [
                    const Icon(Iconsax.flash_1, color: IrmaTheme.pureWhite, size: 28),
                    const SizedBox(width: 8),
                    Text(
                      "irma",
                      style: IrmaTheme.outfit.copyWith(
                        color: IrmaTheme.pureWhite,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                // NOTIFICATION
                const Icon(Iconsax.notification, color: IrmaTheme.pureWhite),
              ],
            ),
          ),
          
          // SECONDARY ROW (Calendar / Profile)
          Positioned(
            bottom: 40,
            left: 24,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Monday, 14 Oct",
                      style: IrmaTheme.inter.copyWith(
                        color: IrmaTheme.pureWhite.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      title,
                      style: IrmaTheme.outfit.copyWith(
                        color: IrmaTheme.pureWhite,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const IrmaSettingsScreen()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: IrmaTheme.pureWhite.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Iconsax.user, color: IrmaTheme.pureWhite, size: 24),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
