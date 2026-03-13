import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/cycle_calculator.dart';
import '../providers/app_state_providers.dart';
import '../models/user_profile.dart';
import 'paywall_screen.dart';
import '../theme/app_colors.dart';
import '../widgets/app_card.dart';
import '../services/health_sync_service.dart';
import '../services/widget_service.dart';
import '../services/feedback_service.dart';
import '../services/notification_service.dart';
import '../services/cycle_sync_manager.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late TextEditingController _cycleController;
  late TextEditingController _periodController;
  final List<String> _availableSymptoms = ['Headache', 'Cramps', 'Fatigue', 'Bloating', 'Mood Swings', 'Acne'];
  List<String> _selectedSymptoms = [];

  @override
  void initState() {
    super.initState();
    final profile = ref.read(userProfileProvider);
    _cycleController = TextEditingController(text: profile?.averageCycleLength.toString() ?? '28');
    _periodController = TextEditingController(text: profile?.averagePeriodLength.toString() ?? '5');
    _selectedSymptoms = List.from(profile?.symptomsToTrack ?? []);
  }

  @override
  void dispose() {
    _cycleController.dispose();
    _periodController.dispose();
    super.dispose();
  }

  Future<void> _saveSettings() async {
    final profile = ref.read(userProfileProvider);
    if (profile == null) return;

    profile.averageCycleLength = int.tryParse(_cycleController.text) ?? 28;
    profile.averagePeriodLength = int.tryParse(_periodController.text) ?? 5;
    profile.symptomsToTrack = _selectedSymptoms;

    await ref.read(userRepositoryProvider).saveUserProfile(profile);
    
    final logs = ref.read(dailyLogsProvider);
    final personalizedLength = CycleCalculator.calculateAverageCycleLength(logs, profile.averageCycleLength);
    await NotificationService.rescheduleAllNotifications(profile, personalizedLength);

    // Refresh the provider state
    ref.read(userProfileProvider.notifier).state = profile;

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Settings saved successfully!')),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $urlString');
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Auntie couldn\'t open that page right now.')),
        );
      }
    }
  }

  void _showFeedbackDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share your thoughts'),
        content: TextField(
          controller: controller,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'What\'s on your mind, love?',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                await FeedbackService.sendFeedback(controller.text, 'General');
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Auntie has heard you. Thank you!')),
                  );
                }
              }
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cycle Defaults',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _cycleController,
              decoration: const InputDecoration(
                labelText: 'Average Cycle Length (days)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _periodController,
              decoration: const InputDecoration(
                labelText: 'Average Period Length (days)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 32),
            const Text(
              'Tracked Symptoms',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Choose which symptoms appear in your daily logger.', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: _availableSymptoms.map((symptom) {
                final isSelected = _selectedSymptoms.contains(symptom);
                return FilterChip(
                  label: Text(symptom),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedSymptoms.add(symptom);
                      } else {
                        _selectedSymptoms.remove(symptom);
                      }
                    });
                  },
                  selectedColor: const Color(0xFFB4A8D3).withOpacity(0.3),
                  checkmarkColor: const Color(0xFFB4A8D3),
                );
              }).toList(),
            ),
            const SizedBox(height: 48),
            const Text(
              'Account',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.star, color: Colors.orange),
              title: const Text('Irma Premium'),
              subtitle: Text(profile?.isPremium == true ? 'Active' : 'Basic Tier'),
              trailing: profile?.isPremium == true 
                ? null 
                : TextButton(
                    onPressed: () => Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => const PaywallScreen())
                    ), 
                    child: const Text('Upgrade')
                  ),
            ),
            const SizedBox(height: 48),
            ListTile(
              leading: const Icon(Icons.notifications_outlined, color: AppColors.primary),
              title: const Text('Notifications'),
              subtitle: const Text('Auntie\'s nudges, frequency, and privacy.'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(context, '/notifications'),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.share_outlined, color: AppColors.primary),
              title: const Text('Partner Sharing'),
              subtitle: const Text('Optional: Manage what you share with your partner.'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(context, '/sharing'),
            ),
            const SizedBox(height: 32),
            const Text(
              'Ecosystem',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.favorite_outline, color: AppColors.primary),
              title: const Text('Health Integration'),
              subtitle: const Text('Sync Sleep & Steps for better insights.'),
              trailing: const Icon(Icons.sync),
              onTap: () async {
                final success = await HealthSyncService.requestPermissions();
                if (success) {
                   final syncManager = CycleSyncManager(ref as WidgetRef);
                   await syncManager.syncWithHealth();
                }
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(success ? 'Health permissions granted, love.' : 'Maybe next time!')),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.widgets_outlined, color: AppColors.primary),
              title: const Text('Update Widgets'),
              subtitle: const Text('Refresh your home screen insight.'),
              onTap: () async {
                final logs = ref.read(dailyLogsProvider);
                // Simple placeholder logic for widget update trigger
                if (profile != null) {
                  final cycleDay = ref.read(currentCycleDayProvider);
                  await WidgetService.updateWidgets(profile, 'Tracking...', 'Open Irma for today\'s wisdom.', cycleDay);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Widgets refreshed!')),
                    );
                  }
                }
              },
            ),
            const SizedBox(height: 32),
            const Text(
              'Privacy & Legal',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined, color: AppColors.primary),
              title: const Text('Privacy Center'),
              subtitle: const Text('See how Auntie Irma guards your secrets.'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(context, '/privacy-center'),
            ),
            ListTile(
              leading: const Icon(Icons.description_outlined, color: AppColors.primary),
              title: const Text('Terms of Service'),
              trailing: const Icon(Icons.open_in_new, size: 16, color: Colors.grey),
              onTap: () => _launchURL('https://irma.app/terms'),
            ),
            ListTile(
              leading: const Icon(Icons.policy_outlined, color: AppColors.primary),
              title: const Text('Privacy Policy'),
              trailing: const Icon(Icons.open_in_new, size: 16, color: Colors.grey),
              onTap: () => _launchURL('https://irma.app/privacy'),
            ),
            const SizedBox(height: 32),
            const Text(
              'Support',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.chat_bubble_outline, color: AppColors.primary),
              title: const Text('Send Feedback'),
              subtitle: const Text('Auntie Irma is always listening.'),
              trailing: const Icon(Icons.chevron_right),
              onTap: _showFeedbackDialog,
            ),
            ListTile(
              leading: const Icon(Icons.help_outline, color: AppColors.primary),
              title: const Text('Help Center'),
              trailing: const Icon(Icons.open_in_new, size: 16, color: Colors.grey),
              onTap: () {},
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _saveSettings,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Save Changes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 24),
            const Center(
              child: Text(
                'Irma v1.0.0 (Production Build)',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
