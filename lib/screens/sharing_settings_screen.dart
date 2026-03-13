import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_state_providers.dart';
import '../models/sharing_settings.dart';
import '../services/sharing_service.dart';
import '../theme/app_colors.dart';
import '../widgets/app_card.dart';

class SharingSettingsScreen extends ConsumerStatefulWidget {
  const SharingSettingsScreen({super.key});

  @override
  ConsumerState<SharingSettingsScreen> createState() => _SharingSettingsScreenState();
}

class _SharingSettingsScreenState extends ConsumerState<SharingSettingsScreen> {
  bool _isEnabled = false;
  bool _sharePhase = true;
  bool _shareMood = false;
  bool _shareSymptoms = false;
  String? _sharingCode;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(userProfileProvider);
    final settings = profile?.sharingSettings ?? SharingSettings();
    _isEnabled = settings.isEnabled;
    _sharePhase = settings.sharePhase;
    _shareMood = settings.shareMood;
    _shareSymptoms = settings.shareSymptoms;
    _sharingCode = settings.sharingCode;
  }

  Future<void> _saveSettings() async {
    final profile = ref.read(userProfileProvider);
    if (profile == null) return;

    final updatedSettings = SharingSettings(
      isEnabled: _isEnabled,
      sharePhase: _sharePhase,
      shareMood: _shareMood,
      shareSymptoms: _shareSymptoms,
      partnerUid: profile.sharingSettings?.partnerUid,
      sharingCode: _sharingCode,
    );

    profile.sharingSettings = updatedSettings;
    await ref.read(userRepositoryProvider).saveUserProfile(profile);
    ref.read(userProfileProvider.notifier).state = profile;

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sharing settings updated.')),
      );
    }
  }

  void _generateCode() {
    setState(() {
      _sharingCode = SharingService.generateSharingCode();
    });
    _saveSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Partner Sharing'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy-First Sharing',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),
            Text(
              'Auntie Irma believes support starts with understanding. This is entirely optional, and you control every bit of data that leaves your device.',
              style: const TextStyle(color: AppColors.textSecondary, height: 1.4),
            ),
            const SizedBox(height: 32),

            SwitchListTile(
              title: const Text('Enable Partner Sharing', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Allow a partner to view specific cycle insights.'),
              value: _isEnabled,
              onChanged: (val) {
                setState(() => _isEnabled = val);
                _saveSettings();
              },
              activeColor: AppColors.primary,
            ),

            const Divider(height: 48),

            if (_isEnabled) ...[
              const Text(
                'What to Share',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildToggleRow('Current Phase', 'Share your current cycle phase (e.g., Luteal).', _sharePhase, (val) {
                setState(() => _sharePhase = val);
                _saveSettings();
              }),
              _buildToggleRow('General Mood', 'Share your daily mood trend (emoji only).', _shareMood, (val) {
                setState(() => _shareMood = val);
                _saveSettings();
              }),
              _buildToggleRow('High-Level Symptoms', 'Share if you are experiencing physical discomfort.', _shareSymptoms, (val) {
                setState(() => _shareSymptoms = val);
                _saveSettings();
              }),

              const Divider(height: 48),

              const Text(
                'Pairing',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              if (_sharingCode == null)
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _generateCode,
                    style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
                    child: const Text('Generate Sharing Code'),
                  ),
                )
              else
              AppCard(
                borderRadius: 24,
                border: Border.all(color: AppColors.border),
                child: Column(
                  children: [
                    const Text('Your Sharing Code', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                    const SizedBox(height: 8),
                    Text(
                      _sharingCode!,
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 4, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Give this code to your partner to pair your accounts. Auntie Irma keeps this secure; codes expire in 24 hours.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    TextButton(onPressed: _generateCode, child: const Text('Generate New Code', style: TextStyle(color: AppColors.primary))),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildToggleRow(String title, String subtitle, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
