import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../theme/irma_theme.dart';
import '../widgets/irma_cards.dart';
import '../widgets/irma_nav_bar.dart';
import '../providers/irma_state_providers.dart';
import 'personal_info_screen.dart';
import 'account_security_screen.dart';
import 'notifications_screen.dart';
import 'support_screen.dart';

class IrmaProfileHubScreen extends ConsumerWidget {
  const IrmaProfileHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(irmaUserProvider);

    return Scaffold(
      body: Stack(
        children: [
          const IrmaNavigationBar(title: 'Profile', showBackButton: true),
          Padding(
            padding: const EdgeInsets.only(top: 287), // Immersive header height
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: IrmaTheme.margin),
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  // Profile Header
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: IrmaTheme.primaryGradient,
                          ),
                          child: const Icon(Iconsax.user, size: 48, color: Colors.white),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          user?.name ?? 'Jane Doe',
                          style: IrmaTheme.outfit.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: IrmaTheme.textMain,
                          ),
                        ),
                        Text(
                          'jane.doe@example.com',
                          style: IrmaTheme.inter.copyWith(
                            fontSize: 14,
                            color: IrmaTheme.textSub,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                  
                  // Menu Tiles
                  IrmaProfileTile(
                    title: 'Personal Information',
                    icon: Iconsax.user_edit,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const IrmaPersonalInfoScreen()),
                      );
                    },
                  ),
                  IrmaProfileTile(
                    title: 'Account & Security',
                    icon: Iconsax.security_user,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const IrmaAccountSecurityScreen()),
                      );
                    },
                  ),
                  IrmaProfileTile(
                    title: 'Notifications',
                    icon: Iconsax.notification,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const IrmaNotificationsScreen()),
                      );
                    },
                  ),
                  IrmaProfileTile(
                    title: 'Help & Support',
                    icon: Iconsax.info_circle,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const IrmaSupportScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  IrmaProfileTile(
                    title: 'Logout',
                    icon: Iconsax.logout,
                    destructive: true,
                    onTap: () {
                      // Handle Logout
                    },
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
}
