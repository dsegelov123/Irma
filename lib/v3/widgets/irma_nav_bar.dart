import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../theme/irma_theme.dart';
import '../screens/profile_hub_screen.dart';

class IrmaNavigationBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final bool showBackButton;
  final bool isChat;

  const IrmaNavigationBar({
    super.key,
    this.title = "Irma",
    this.subtitle,
    this.showBackButton = false,
    this.isChat = false,
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
          topLeft: Radius.circular(IrmaTheme.radiusLarge),
          topRight: Radius.circular(IrmaTheme.radiusLarge),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(IrmaTheme.radiusLarge),
          topRight: Radius.circular(IrmaTheme.radiusLarge),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Stack(
            children: [
              // Chat Navbar Variant content
              if (isChat)
                _buildChatNavbar(context)
              else
                _buildDefaultNavbar(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatNavbar(BuildContext context) {
    return Positioned(
      top: 64, 
      left: 0,
      right: 0,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back_ios, color: IrmaTheme.pureWhite, size: 20),
                ),
                const SizedBox(width: 16),
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: IrmaTheme.ovulation,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.auto_awesome, color: IrmaTheme.pureWhite, size: 24),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: IrmaTheme.outfit.copyWith(
                        color: IrmaTheme.pureWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: IrmaTheme.inter.copyWith(
                          color: IrmaTheme.pureWhite.withOpacity(0.8),
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultNavbar(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 64, 
          left: 24,
          right: 24,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (showBackButton)
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Padding(
                        padding: EdgeInsets.only(right: 16),
                        child: Icon(Icons.arrow_back_ios, color: IrmaTheme.pureWhite, size: 20),
                      ),
                    ),
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
              const Icon(Iconsax.notification, color: IrmaTheme.pureWhite),
            ],
          ),
        ),
        Positioned(
          bottom: 64,
          left: 24,
          right: 24,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Today's Insight",
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
                    MaterialPageRoute(builder: (context) => const IrmaProfileHubScreen()),
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
    );
  }
}
