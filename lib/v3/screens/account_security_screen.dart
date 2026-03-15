import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../theme/irma_theme.dart';
import '../widgets/irma_nav_bar.dart';
import '../widgets/irma_cards.dart';
import '../services/irma_security_service.dart';
import 'settings_screen.dart'; // Reusing irmaLockEnabledProvider for continuity

final irmaTwoFactorEnabledProvider = StateProvider<bool>((ref) => false);

class IrmaAccountSecurityScreen extends ConsumerWidget {
  const IrmaAccountSecurityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lockEnabled = ref.watch(irmaLockEnabledProvider);
    final twoFactorEnabled = ref.watch(irmaTwoFactorEnabledProvider);

    return Scaffold(
      body: Stack(
        children: [
          const IrmaNavigationBar(title: 'Security', showBackButton: true),
          Padding(
            padding: const EdgeInsets.only(top: 287), // Immersive header height
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(IrmaTheme.margin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionLabel("Access Control"),
                  const SizedBox(height: 16),
                  
                  // Login Credentials
                  IrmaProfileTile(
                    title: 'Change Password',
                    icon: Iconsax.key,
                    onTap: () {
                      // Placeholder for change password flow
                    },
                  ),
                  
                  // Biometrics
                  _buildSwitchTile(
                    context: context,
                    title: 'Biometric Lock',
                    icon: Iconsax.finger_scan,
                    value: lockEnabled,
                    onChanged: (val) async {
                      if (val) {
                        final available = await ref.read(irmaSecurityServiceProvider).isBiometricAvailable();
                        if (!available) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Biometrics not available on this device.")),
                          );
                          return;
                        }
                      }
                      ref.read(irmaLockEnabledProvider.notifier).state = val;
                    },
                  ),
                  
                  const SizedBox(height: 32),
                  
                  _buildSectionLabel("Extra Protection"),
                  const SizedBox(height: 16),
                  
                  // 2FA
                  _buildSwitchTile(
                    context: context,
                    title: 'Two-Factor Auth',
                    icon: Iconsax.shield_tick,
                    value: twoFactorEnabled,
                    onChanged: (val) {
                      ref.read(irmaTwoFactorEnabledProvider.notifier).state = val;
                      if (val) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Auntie will prompt for a code on your next login."),
                            backgroundColor: IrmaTheme.follicular,
                          ),
                        );
                      }
                    },
                  ),
                  
                  const SizedBox(height: 48),
                  
                  _buildSectionLabel("Danger Zone"),
                  const SizedBox(height: 16),
                  IrmaProfileTile(
                    title: 'Delete Account',
                    icon: Iconsax.trash,
                    destructive: true,
                    onTap: () {
                      // Placeholder for delete flow
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

  Widget _buildSwitchTile({
    required BuildContext context,
    required String title,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      width: 345,
      height: 64,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: IrmaTheme.pureWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: IrmaTheme.borderLight),
      ),
      child: Center(
        child: ListTile(
          leading: Icon(icon, color: IrmaTheme.menstrual),
          title: Text(
            title,
            style: IrmaTheme.inter.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: IrmaTheme.textMain,
            ),
          ),
          trailing: Switch(
            value: value,
            activeColor: IrmaTheme.menstrual,
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
