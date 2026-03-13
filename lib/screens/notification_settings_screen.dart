import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_state_providers.dart';
import '../models/notification_settings.dart';
import '../theme/app_colors.dart';
import '../widgets/app_card.dart';
import '../services/notification_service.dart';

class NotificationSettingsScreen extends ConsumerStatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  ConsumerState<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends ConsumerState<NotificationSettingsScreen> {
  late bool _isEnabled;
  late bool _isPrivateMode;
  late NotificationFrequency _frequency;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(userProfileProvider);
    final settings = profile?.notificationSettings ?? NotificationSettings();
    _isEnabled = settings.isEnabled;
    _isPrivateMode = settings.isPrivateMode;
    _frequency = settings.frequency;
  }

  Future<void> _saveSettings() async {
    final profile = ref.read(userProfileProvider);
    if (profile == null) return;

    final updatedSettings = NotificationSettings(
      isEnabled: _isEnabled,
      isPrivateMode: _isPrivateMode,
      frequency: _frequency,
    );

    profile.notificationSettings = updatedSettings;
    await ref.read(userRepositoryProvider).saveUserProfile(profile);
    ref.read(userProfileProvider.notifier).state = profile;

    if (_isEnabled) {
      await NotificationService.requestPermissions();
      // Re-schedule logic would go here
    } else {
      await NotificationService.cancelAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Auntie\'s Nudges',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),
            Text(
              'Auntie Irma likes to check in from time to time to see how you\'re getting on. You decide how often she visits.',
              style: const TextStyle(color: AppColors.textSecondary, height: 1.4),
            ),
            const SizedBox(height: 32),

            AppCard(
              borderRadius: 24,
              child: SwitchListTile(
                title: const Text('Allow Notifications', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Get gentle reminders and phase updates.'),
                value: _isEnabled,
                onChanged: (val) {
                  setState(() => _isEnabled = val);
                  _saveSettings();
                },
                activeColor: AppColors.primary,
              ),
            ),

            const SizedBox(height: 24),

            if (_isEnabled) ...[
              Text(
                'Privacy Setting',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 16),
              AppCard(
                borderRadius: 24,
                child: SwitchListTile(
                  title: const Text('Private Mode', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text('Hides Auntie\'s voice from your lock screen for discretion.'),
                  value: _isPrivateMode,
                  onChanged: (val) {
                    setState(() => _isPrivateMode = val);
                    _saveSettings();
                  },
                  activeColor: AppColors.primary,
                ),
              ),

              const SizedBox(height: 32),

              Text(
                'Frequency',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 16),
              AppCard(
                borderRadius: 24,
                child: Column(
                  children: [
                    _buildFrequencyTile(NotificationFrequency.high, 'Regular', 'Daily check-ins & phase alerts.'),
                    _buildFrequencyTile(NotificationFrequency.medium, 'Occasional', 'Phase change alerts only.'),
                    _buildFrequencyTile(NotificationFrequency.low, 'Quiet', 'Only critical cycle predictions.'),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFrequencyTile(NotificationFrequency freq, String title, String subtitle) {
    return RadioListTile<NotificationFrequency>(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      value: freq,
      groupValue: _frequency,
      onChanged: (val) {
        if (val != null) {
          setState(() => _frequency = val);
          _saveSettings();
        }
      },
      activeColor: AppColors.primary,
    );
  }
}
