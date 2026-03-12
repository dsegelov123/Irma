import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsDashboard extends StatelessWidget {
  const AnalyticsDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Analytics'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Energy vs. Cycle Phase',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'A multi-month view of your energy patterns.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),

              // Mock fl_chart (LineChart)
              SizedBox(
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
                          getTitlesWidget: (value, meta) {
                            switch (value.toInt()) {
                              case 1: return const Text('Day 1');
                              case 7: return const Text('Day 7');
                              case 14: return const Text('Day 14');
                              case 21: return const Text('Day 21');
                              case 28: return const Text('Day 28');
                            }
                            return const Text('');
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: const [
                          FlSpot(1, 2),
                          FlSpot(4, 3),
                          FlSpot(7, 4),
                          FlSpot(14, 5),
                          FlSpot(21, 3),
                          FlSpot(25, 2),
                          FlSpot(28, 1),
                        ],
                        isCurved: true,
                        color: const Color(0xFF6C63FF),
                        barWidth: 4,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: const Color(0xFF6C63FF).withOpacity(0.2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 48),

              const Text(
                'Symptom Frequency',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              // Mock fl_chart (BarChart)
              SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 10,
                    barTouchData: BarTouchData(enabled: false),
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 10);
                            Widget text;
                            switch (value.toInt()) {
                              case 0: text = const Text('Headache', style: style); break;
                              case 1: text = const Text('Cramps', style: style); break;
                              case 2: text = const Text('Fatigue', style: style); break;
                              case 3: text = const Text('Bloating', style: style); break;
                              default: text = const Text(''); break;
                            }
                            return SideTitleWidget(axisSide: meta.axisSide, child: text);
                          },
                        ),
                      ),
                    ),
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    barGroups: [
                      BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 8, color: const Color(0xFFB4A8D3))]),
                      BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 6, color: const Color(0xFFB4A8D3))]),
                      BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 9, color: const Color(0xFFB4A8D3))]),
                      BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 4, color: const Color(0xFFB4A8D3))]),
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
}
