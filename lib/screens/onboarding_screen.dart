import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile.dart';
import '../models/cycle_data.dart';
import '../providers/app_state_providers.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  DateTime? _lastPeriodDate;
  int _cycleLength = 28;
  final List<String> _selectedSymptoms = [];

  final List<String> _availableSymptoms = [
    'Headache',
    'Cramps',
    'Fatigue',
    'Bloating',
    'Acne',
    'Breast Tenderness',
    'Anxiety',
    'Insomnia',
  ];

  Future<void> _finishOnboarding() async {
    if (_lastPeriodDate == null) return;

    final profile = UserProfile(
      onboardingDate: DateTime.now(),
      averageCycleLength: _cycleLength,
      symptomsToTrack: _selectedSymptoms,
    );

    final initialCycle = CycleData(
      startDate: _lastPeriodDate!,
      cycleLength: _cycleLength,
    );

    // Save to Hive via Repository
    await ref.read(userRepositoryProvider).saveUserProfile(profile);
    
    // We should also save the initial cycle data, 
    // but for now the profile triggers the home screen switch.
    // In a more robust app, we'd use a dedicated CycleRepository.

    // Update state to trigger navigation in main.dart
    ref.read(userProfileProvider.notifier).state = profile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome to Irma')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Let\'s personalize your experience.',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),

              // Step 1: Last Period Date
              const Text('1. When did your last period start?', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now().subtract(const Duration(days: 90)),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    setState(() => _lastPeriodDate = date);
                  }
                },
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  _lastPeriodDate == null 
                      ? 'Select Date' 
                      : '${_lastPeriodDate!.year}-${_lastPeriodDate!.month}-${_lastPeriodDate!.day}'
                ),
              ),
              const SizedBox(height: 32),

              // Step 2: Average Cycle Length
              const Text('2. Average cycle length (days)?', style: TextStyle(fontWeight: FontWeight.bold)),
              Slider(
                value: _cycleLength.toDouble(),
                min: 20,
                max: 45,
                divisions: 25,
                label: _cycleLength.toString(),
                onChanged: (val) {
                  setState(() => _cycleLength = val.toInt());
                },
              ),
              const SizedBox(height: 32),

              // Step 3: Symptoms to track
              const Text('3. Which symptoms do you want to track?', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
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
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _lastPeriodDate == null ? null : _finishOnboarding,
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Start Tracking', style: TextStyle(fontSize: 16)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
