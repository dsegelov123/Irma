import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../theme/irma_theme.dart';
import '../widgets/irma_nav_bar.dart';
import '../providers/irma_state_providers.dart';

class IrmaNotificationsScreen extends ConsumerWidget {
  const IrmaNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final periodReminders = ref.watch(irmaPeriodRemindersProvider);
    final symptomLogs = ref.watch(irmaSymptomLogsProvider);
    final aiInsights = ref.watch(irmaAIInsightsNotificationsProvider);
    final communityAlerts = ref.watch(irmaCommunityAlertsProvider);

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 80, 24, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionLabel("Cycle Alerts"),
                  const SizedBox(height: 16),
                  _buildSwitchTile(
                    title: 'Period Reminders',
                    subtitle: 'Notifications for your upcoming period',
                    icon: Iconsax.calendar_2,
                    value: periodReminders,
                    onChanged: (val) => ref.read(irmaPeriodRemindersProvider.notifier).state = val,
                  ),
                  _buildSwitchTile(
                    title: 'Symptom Logging',
                    subtitle: 'Daily reminders to log your feelings',
                    icon: Iconsax.edit_2,
                    value: symptomLogs,
                    onChanged: (val) => ref.read(irmaSymptomLogsProvider.notifier).state = val,
                  ),
                  
                  const SizedBox(height: 32),
                  _buildSectionLabel("App Updates"),
                  const SizedBox(height: 16),
                  _buildSwitchTile(
                    title: 'AI Insights',
                    subtitle: 'Get notified when Auntie has new wisdom',
                    icon: Iconsax.magicpen,
                    value: aiInsights,
                    onChanged: (val) => ref.read(irmaAIInsightsNotificationsProvider.notifier).state = val,
                  ),
                  _buildSwitchTile(
                    title: 'Community Activity',
                    subtitle: 'Alerts for replies and thread updates',
                    icon: Iconsax.messages_3,
                    value: communityAlerts,
                    onChanged: (val) => ref.read(irmaCommunityAlertsProvider.notifier).state = val,
                  ),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          // TOP NAV
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: IrmaNavigationBar(title: 'Notifications', showBackButton: true),
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
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      width: 345,
      height: 72,
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
          subtitle: Text(
            subtitle,
            style: IrmaTheme.inter.copyWith(
              fontSize: 11,
              color: IrmaTheme.textSub,
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
