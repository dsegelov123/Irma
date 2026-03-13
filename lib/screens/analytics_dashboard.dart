import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_state_providers.dart';
import '../models/daily_log.dart';
import '../theme/app_colors.dart';
import '../widgets/app_card.dart';

class AnalyticsDashboard extends ConsumerWidget {
  const AnalyticsDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logs = ref.watch(dailyLogsProvider);
    final profile = ref.watch(userProfileProvider);

    if (profile == null) {
      return const Scaffold(body: Center(child: Text('Profile not found.')));
    }

    if (logs.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Trends')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.show_chart, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text('No data yet.', style: TextStyle(fontSize: 18, color: Colors.grey)),
              const SizedBox(height: 8),
              const Text('Keep logging daily to see your patterns!'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Go Back'),
              )
            ],
          ),
        ),
      );
    }

    // Determine current cycle phase for dynamic coloring via providers
    final currentDayInCycle = ref.watch(currentCycleDayProvider);
    final currentPhase = ref.watch(currentPhaseProvider);
    final phaseColor = AppColors.getPhaseColor(currentPhase);

    return Scaffold(
      backgroundColor: phaseColor.withOpacity(0.05),
      appBar: AppBar(
        title: Text(
          'Trends & History',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontFamily: 'Lufga'),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Cycle Intelligence',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.textPrimary,
                fontFamily: 'Lufga',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Auntie Irma\'s multi-month view of your energy patterns.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary, fontFamily: 'Inter'),
            ),
            const SizedBox(height: 24),

            // Real Energy Chart
            AppCard(
              borderRadius: 24,
              child: SizedBox(
                height: 250,
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 7,
                          getTitlesWidget: (value, meta) {
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              child: Text('Day ${value.toInt()}', style: const TextStyle(fontSize: 10, color: AppColors.textSecondary, fontFamily: 'Inter')),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: _generateEnergySpots(logs, profile.onboardingDate, profile.averageCycleLength),
                        isCurved: true,
                        color: phaseColor, // Use phase-based color
                        barWidth: 4,
                        isStrokeCapRound: true,
                        dotData: FlDotData(show: true, color: phaseColor), // Use phase-based color for dots
                        belowBarData: BarAreaData(
                          show: true,
                          color: phaseColor.withOpacity(0.1), // Use phase-based color
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 48),

            Text(
              'Symptom Frequency',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 18,
                color: AppColors.textPrimary,
                fontFamily: 'Lufga',
              ),
            ),
            const SizedBox(height: 24),

            // Real Symptom Bar Chart
            AppCard(
              borderRadius: 24,
              child: SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: logs.length.toDouble(),
                    barTouchData: BarTouchData(enabled: true),
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            final symptomNames = ['Headache', 'Cramps', 'Fatigue', 'Bloating'];
                            if (value.toInt() < symptomNames.length) {
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                child: Text(symptomNames[value.toInt()], style: const TextStyle(fontSize: 10, color: AppColors.textSecondary, fontFamily: 'Inter')),
                              );
                  height: 200,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: logs.length.toDouble(),
                      barTouchData: BarTouchData(enabled: true),
                      titlesData: FlTitlesData(
                        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              final symptomNames = ['Headache', 'Cramps', 'Fatigue', 'Bloating'];
                              if (value.toInt() < symptomNames.length) {
                                return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  child: Text(symptomNames[value.toInt()], style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                                );
                              }
                              return const SizedBox();
                            },
                          ),
                        ),
                      ),
                      gridData: const FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      barGroups: _generateSymptomGroups(logs),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<FlSpot> _generateEnergySpots(List<DailyLog> logs, DateTime onboardingDate, int cycleLength) {
    // Map logs to cycle days and average the energy if multiple logs exist for same cycle day
    final Map<int, List<int>> energyByDay = {};

    for (var log in logs) {
      final cycleDay = CycleCalculator.getCycleDayForDate(onboardingDate, log.date, cycleLength);
      energyByDay.putIfAbsent(cycleDay, () => []).add(log.energyLevel);
    }

    final List<FlSpot> spots = [];
    final sortedDays = energyByDay.keys.toList()..sort();

    for (var day in sortedDays) {
      final avgEnergy = energyByDay[day]!.reduce((a, b) => a + b) / energyByDay[day]!.length;
      spots.add(FlSpot(day.toDouble(), avgEnergy));
    }

    return spots;
  }

  List<BarChartGroupData> _generateSymptomGroups(List<DailyLog> logs) {
    final symptomCounts = {
      'Headache': 0,
      'Cramps': 0,
      'Fatigue': 0,
      'Bloating': 0,
    };

    for (var log in logs) {
      for (var symptom in log.symptoms) {
        if (symptomCounts.containsKey(symptom)) {
          symptomCounts[symptom] = symptomCounts[symptom]! + 1;
        }
      }
    }

    return [
      _makeGroupData(0, symptomCounts['Headache']!.toDouble()),
      _makeGroupData(1, symptomCounts['Cramps']!.toDouble()),
      _makeGroupData(2, symptomCounts['Fatigue']!.toDouble()),
      _makeGroupData(3, symptomCounts['Bloating']!.toDouble()),
    ];
  }

  BarChartGroupData _makeGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: AppColors.luteal,
          width: 22,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
        ),
      ],
    );
  }
}
