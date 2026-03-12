import 'package:flutter/material.dart';
import '../widgets/cycle_ring.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _energyLevel = 3;
  String? _selectedMood;
  final List<String> _selectedSymptoms = [];

  final List<String> _moods = ['😊', '😐', '😔', '😡'];
  final List<String> _symptoms = ['Headache', 'Cramps', 'Fatigue', 'Bloating'];

  // Mock data for UI 
  final int currentDay = 18;
  final int totalLength = 28;
  final String phase = 'Luteal Phase';
  final String aiInsight = "Energy may be lower today.";

  void _saveDailyLog() {
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(content: Text('Daily log saved!')),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Irma'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
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
                totalCycleLength: totalLength,
                currentPhase: phase,
              ),
              const SizedBox(height: 32),

              // Middle: AI Insight
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F0FA), // Very light purple
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.auto_awesome, color: Color(0xFFB4A8D3)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Insight',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6C63FF),
                            ),
                          ),
                          Text(aiInsight),
                        ],
                      ),
                    ),
                  ],
                ),
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
                        color: isSelected ? const Color(0xFFB4A8D3).withOpacity(0.3) : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? const Color(0xFF6C63FF) : Colors.grey.shade300,
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
                    selectedColor: const Color(0xFFB4A8D3).withOpacity(0.4),
                    checkmarkColor: const Color(0xFF6C63FF),
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
                activeColor: const Color(0xFF6C63FF),
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
                    backgroundColor: const Color(0xFF6C63FF),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
