import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../theme/irma_theme.dart';
import '../widgets/irma_nav_bar.dart';
import '../services/irma_security_service.dart';

final irmaLockEnabledProvider = StateProvider<bool>((ref) => false);

class IrmaSettingsScreen extends ConsumerWidget {
  const IrmaSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lockEnabled = ref.watch(irmaLockEnabledProvider);

    return Scaffold(
      backgroundColor: IrmaTheme.pureWhite,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 80, bottom: 40, left: 24, right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Settings",
                  style: IrmaTheme.outfit.copyWith(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),

                // 1. PRIVACY & SECURITY
                _buildSectionLabel("Privacy & Security"),
                const SizedBox(height: 16),
                _buildSettingsTile(
                  icon: Iconsax.lock,
                  title: "Biometric Lock",
                  subtitle: "Required FaceID/Fingerprint to open Irma",
                  trailing: Switch(
                    value: lockEnabled,
                    activeColor: IrmaTheme.menstrual,
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
                ),
                _buildSettingsTile(
                  icon: Iconsax.eye_slash,
                  title: "Incognito Mode",
                  subtitle: "Local-only data logging",
                  onTap: () {},
                ),

                const SizedBox(height: 40),

                // 2. DATA MANAGEMENT
                _buildSectionLabel("Data Management"),
                const SizedBox(height: 16),
                _buildSettingsTile(
                  icon: Iconsax.export_1,
                  title: "Export Health Data",
                  subtitle: "Download your cycle history as PDF/JSON",
                  onTap: () {},
                ),
                _buildSettingsTile(
                  icon: Iconsax.trash,
                  title: "Delete Account",
                  subtitle: "Permanently remove all cloud and local data",
                  isDestructive: true,
                  onTap: () {},
                ),

                const SizedBox(height: 40),

                // 3. ABOUT
                _buildSectionLabel("About"),
                const SizedBox(height: 16),
                _buildSettingsTile(
                  icon: Iconsax.info_circle,
                  title: "Privacy Policy",
                  onTap: () {},
                ),
                _buildSettingsTile(
                  icon: Iconsax.star,
                  title: "Rate Irma",
                  onTap: () {},
                ),
              ],
            ),
          ),

          // TOP NAV
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: IrmaNavigationBar(
              title: "Privacy Center",
              showBackButton: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: IrmaTheme.inter.copyWith(
        color: IrmaTheme.textSub,
        fontWeight: FontWeight.bold,
        fontSize: 14,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    bool isDestructive = false,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isDestructive ? Colors.red.withOpacity(0.05) : IrmaTheme.borderLight.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: isDestructive ? Colors.red : IrmaTheme.textMain, size: 22),
      ),
      title: Text(
        title,
        style: IrmaTheme.outfit.copyWith(
          fontWeight: FontWeight.bold,
          color: isDestructive ? Colors.red : IrmaTheme.textMain,
        ),
      ),
      subtitle: subtitle != null ? Text(subtitle, style: IrmaTheme.inter.copyWith(color: IrmaTheme.textSub, fontSize: 13)) : null,
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 14, color: IrmaTheme.textSub),
      onTap: onTap,
    );
  }
}
