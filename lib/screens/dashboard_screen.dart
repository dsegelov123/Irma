import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/cycle_ring.dart';
import '../widgets/app_card.dart';
import '../theme/app_colors.dart';
import '../providers/app_state_providers.dart';
import '../models/daily_log.dart';
import '../services/cycle_calculator.dart';
import '../services/ai_insight_service.dart';
import '../models/cycle_data.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _energyLevel = 3;
  String? _selectedMood;
  final List<String> _selectedSymptoms = [];

  final List<String> _moods = ['😊', '😐', '😔', '😡'];
  final List<String> _symptoms = ['Headache', 'Cramps', 'Fatigue', 'Bloating'];

  String _aiInsight = "Loading your insight...";
  bool _isLoadingInsight = true;

  @override
  void initState() {
    super.initState();
    _loadTodayLog();
    _fetchAIInsight();
  }

  void _loadTodayLog() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final log = ref.read(logRepositoryProvider).getLogForDate(DateTime.now());
      if (log != null) {
        setState(() {
          _energyLevel = log.energyLevel;
          _selectedMood = log.mood;
          _selectedSymptoms.clear();
          _selectedSymptoms.addAll(log.symptoms);
        });
      }
    });
  }

  Future<void> _fetchAIInsight() async {
    final profile = ref.read(userProfileProvider);
    final logs = ref.read(dailyLogsProvider);
    
    if (profile == null) return;

    // Check Cache (if it's the same day)
    final now = DateTime.now();
    final isSameDay = profile.lastInsightDate != null &&
        profile.lastInsightDate!.year == now.year &&
        profile.lastInsightDate!.month == now.month &&
        profile.lastInsightDate!.day == now.day;

    if (isSameDay && profile.lastInsight != null) {
      if (mounted) {
        setState(() {
          _aiInsight = profile.lastInsight!;
          _isLoadingInsight = false;
        });
      }
      return;
    }

    // Otherwise fetch new insight
    final currentCycle = CycleData(
      startDate: profile.onboardingDate, 
      cycleLength: profile.averageCycleLength,
    );

    final phase = CycleCalculator.getCurrentPhase(
      currentCycle.startDate, 
      profile.averageCycleLength, 
      profile.averagePeriodLength
    );

    final insight = await AIInsightService.generateDailyInsight(
      recentLogs: logs,
      currentCycle: currentCycle,
      currentPhase: phase,
      isPremium: profile.isPremium,
    );

    // Save to Cache
    profile.lastInsight = insight;
    profile.lastInsightDate = DateTime.now();
    await ref.read(userRepositoryProvider).saveUserProfile(profile);

    if (mounted) {
      setState(() {
        _aiInsight = insight;
        _isLoadingInsight = false;
      });
    }
  }

  Future<void> _saveDailyLog() async {
    if (_selectedMood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a mood first!')),
      );
      return;
    }

    final log = DailyLog(
      date: DateTime.now(),
      energyLevel: _energyLevel,
      mood: _selectedMood!,
      symptoms: List.from(_selectedSymptoms),
    );

    await ref.read(logRepositoryProvider).saveLog(log);
    
    // Refresh the logs provider
    ref.read(dailyLogsProvider.notifier).state = ref.read(logRepositoryProvider).getAllLogs();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Daily log saved!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider);
    
    if (profile == null) {
      return const Scaffold(body: Center(child: Text("Profile not found")));
    }

    // Dynamic cycle calculations
    final currentDay = (DateTime.now().difference(profile.onboardingDate).inDays % profile.averageCycleLength) + 1;
    final phase = CycleCalculator.getCurrentPhase(
      profile.onboardingDate, 
      profile.averageCycleLength, 
      profile.averagePeriodLength
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Irma', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top: Cycle Ring
              CycleRing(
                currentDayOfCycle: currentDay,
                totalCycleLength: profile.averageCycleLength,
                currentPhase: phase,
              ),
              const SizedBox(height: 32),

              // Middle: AI Insight (The Insight Spark)
              AppCard(
                padding: EdgeInsets.zero,
                border: Border.all(color: Colors.transparent),
                borderRadius: 20,
                child: Container(
                  padding: const EdgeInsets.all(1.5), // The Gradient Border thickness
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [AppColors.aiSparkStart, AppColors.aiSparkEnd],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.aiSparkEnd.withOpacity(0.2),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(19),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.auto_awesome, color: AppColors.primary, size: 20),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Auntie Irma\'s Insight',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _isLoadingInsight 
                                ? const LinearProgressIndicator(minHeight: 2, backgroundColor: AppColors.background)
                                : Text(
                                    _aiInsight,
                                    style: const TextStyle(fontSize: 15, height: 1.4, color: AppColors.textPrimary),
                                  ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Dashboard Navigation Buttons
              Row(
                children: [
                   Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pushNamed(context, '/analytics'),
                      icon: const Icon(Icons.trending_up),
                      label: const Text('Trends'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pushNamed(context, '/wellness'),
                      icon: const Icon(Icons.spa),
                      label: const Text('Wellness'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Bottom: Quick Logging
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('How are you feeling?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 16),
              
              // Mood
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _moods.map((mood) {
                  final isSelected = _selectedMood == mood;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedMood = mood),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary.withOpacity(0.2) : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors.border,
                        ),
                      ),
                      child: Text(mood, style: const TextStyle(fontSize: 32)),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Symptoms
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Symptoms', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: _symptoms.map((symptom) {
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
                    selectedColor: AppColors.primarySoft,
                    checkmarkColor: AppColors.primary,
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Energy Slider
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Energy Level', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              Slider(
                value: _energyLevel.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                activeColor: AppColors.primary,
                onChanged: (val) => setState(() => _energyLevel = val.toInt()),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Low', style: TextStyle(color: Colors.grey)),
                    Text('High', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),

              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _saveDailyLog,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                  ),
                  child: const Text('Log Today', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
