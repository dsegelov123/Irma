import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_state_providers.dart';
import '../theme/app_colors.dart';
import '../widgets/app_card.dart';
import '../services/export_service.dart';

class PrivacyCenterScreen extends ConsumerWidget {
  const PrivacyCenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);
    final logs = ref.watch(dailyLogsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Center'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Guarding Your Secrets',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),
            Text(
              'Auntie Irma believes what happens in our conversations stays between us. Here is how I protect your privacy, love.',
              style: const TextStyle(color: AppColors.textSecondary, height: 1.4),
            ),
            const SizedBox(height: 32),

            _buildPrivacyTile(
              Icons.lock_outline,
              '100% Local Storage',
              'Your health data never leaves this phone. It is stored in a secure, encrypted vault right here in your pocket.',
            ),
            const SizedBox(height: 16),
            _buildPrivacyTile(
              Icons.visibility_off_outlined,
              'Anonymized AI',
              'When I ask the AI for insights, I strip away your identity first. It sees patterns, not people.',
            ),
            const SizedBox(height: 16),
            _buildPrivacyTile(
              Icons.shield_outlined,
              'No Accounts Needed',
              'I don\'t need your email or phone number to support you. You are more than a line in a database.',
            ),

            const SizedBox(height: 48),
            Text(
              'Data Ownership',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),
            AppCard(
              borderRadius: 24,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'It is your data, and you should be able to take it with you. Use the button below to generate a CSV report for your records or your doctor.',
                      style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () {
                          if (profile != null) {
                            ExportService.exportToCsv(profile, logs);
                          }
                        },
                        icon: const Icon(Icons.download_outlined),
                        label: const Text('Download My Data (CSV)'),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyTile(IconData icon, String title, String description) {
    return AppCard(
      borderRadius: 24,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
