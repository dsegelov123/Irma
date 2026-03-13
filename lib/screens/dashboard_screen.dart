import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/cycle_ring.dart';
import '../widgets/weekly_strip.dart';
import '../widgets/kawaii_asset.dart';
import '../theme/app_colors.dart';
import '../providers/app_state_providers.dart';
import '../models/daily_log.dart';
import '../services/cycle_calculator.dart';
import '../services/ai_insight_service.dart';
import '../models/cycle_data.dart';
import '../services/widget_service.dart';
import '../services/cycle_sync_manager.dart';
import '../providers/app_state_providers.dart';

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
    _syncHealthData();
  }

  Future<void> _syncHealthData() async {
     // Trigger passive health ingestion on load
     final syncManager = CycleSyncManager(ref as WidgetRef);
     await syncManager.syncWithHealth();
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

    final phase = ref.read(currentPhaseProvider);
    final personalizedLength = ref.read(personalizedCycleLengthProvider);
    final cycleDay = ref.read(currentCycleDayProvider);

    final currentCycle = CycleData(
      startDate: profile.onboardingDate, 
      cycleLength: personalizedLength,
    );

    final insight = await AIInsightService.generateDailyInsight(
      recentLogs: logs,
      currentCycle: currentCycle,
      currentPhase: phase,
      cycleDay: cycleDay,
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
      // Update Home Screen Widget
      await WidgetService.updateWidgets(profile, phase, insight, cycleDay);
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
      
      // Update widgets to reflect "Logged" state if needed
      final profile = ref.read(userProfileProvider);
      if (profile != null) {
        final phase = ref.read(currentPhaseProvider);
        final cycleDay = ref.read(currentCycleDayProvider);
        WidgetService.updateWidgets(profile, phase, profile.lastInsight ?? "Log today to see your insight.", cycleDay);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider);
    
    if (profile == null) {
      return const Scaffold(body: Center(child: Text("Profile not found")));
    }

    // Dynamic cycle calculations using global providers
    final currentPhase = ref.watch(currentPhaseProvider);
    final personalizedLength = ref.watch(personalizedCycleLengthProvider);
    final currentDay = ref.watch(currentCycleDayProvider);

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider);
    
    if (profile == null) {
      return const Scaffold(body: Center(child: Text("Profile not found")));
    }

    final currentPhase = ref.watch(currentPhaseProvider);
    final personalizedLength = ref.watch(personalizedCycleLengthProvider);
    final currentDay = ref.watch(currentCycleDayProvider);

    final phaseColor = AppColors.getPhaseColor(currentPhase);
    final surfaceWash = AppColors.getSurfaceWash(currentPhase);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          color: surfaceWash.withOpacity(0.4),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 1. Bespoke Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.notes, color: Colors.grey),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Hi, Gargi',
                          style: TextStyle(
                            fontFamily: 'Lufga',
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications_none_outlined, color: Colors.grey),
                      onPressed: () {},
                    )
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: [
                      // 2. Weekly Date Strip
                      WeeklyStrip(selectedDate: DateTime.now()),
                      
                      const SizedBox(height: 32),

                      // 3. Cycle Ring
                      CycleRing(
                        currentDayOfCycle: currentDay,
                        totalCycleLength: personalizedLength,
                        currentPhase: currentPhase,
                      ),
                      const SizedBox(height: 32),

                      // 4. Insight Card (The Spark)
                      _buildInsightCard(context),

                      const SizedBox(height: 32),

                      // 5. Straight Quick-Logging Cards
                      _buildQuickLogSection(),
                      
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInsightCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const KawaiiAsset.mood(KawaiiMood.thinking, size: 24),
                const SizedBox(width: 12),
                Text(
                  "Auntie's Observation",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 16,
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _isLoadingInsight
                ? const LinearProgressIndicator(minHeight: 2, backgroundColor: Color(0xFFF7F6F6))
                : Text(
                    _aiInsight,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickLogSection() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          _buildLoggingCard(KawaiiMood.happy, 'Mood', const Color(0xFFFFF2EF)),
          _buildLoggingCard(KawaiiMood.sad, 'Cramps', const Color(0xFFFFF2F5)),
          _buildLoggingCard(KawaiiMood.sleepy, 'Drugs', const Color(0xFFEFFAFF)),
        ],
      ),
    );
  }

  Widget _buildLoggingCard(KawaiiMood mood, String label, Color bgColor) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          KawaiiAsset.mood(mood, size: 48),
          const SizedBox(height: 12),
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          const Text('how are you\nfeeling?', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }
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
