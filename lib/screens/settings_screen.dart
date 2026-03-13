import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_state_providers.dart';
import '../models/user_profile.dart';
import 'paywall_screen.dart';

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
    
    // Refresh the provider state
    ref.read(userProfileProvider.notifier).state = profile;

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Settings saved successfully!')),
      );
      Navigator.pop(context);
    }
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
              leading: const Icon(Icons.share_outlined),
              title: const Text('Partner Sharing'),
              subtitle: const Text('Optional: Manage what you share with your partner.'),
              trailing: const Icon(Icons.chevron_right),
              onPressed: () => Navigator.pushNamed(context, '/sharing'),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveSettings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB4A8D3),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Save Changes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
