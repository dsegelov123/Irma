import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:iconsax/iconsax.dart';
import '../theme/irma_theme.dart';
import '../widgets/irma_nav_bar.dart';
import '../widgets/irma_cards.dart';

class IrmaInsightsScreen extends StatelessWidget {
  const IrmaInsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: IrmaTheme.pureWhite,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 80, bottom: 120, left: 24, right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Deep Trends",
                  style: IrmaTheme.outfit.copyWith(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  "Understand your body's rhythm over time.",
                  style: IrmaTheme.inter.copyWith(color: IrmaTheme.textSub),
                ),
                const SizedBox(height: 32),

                // 1. SYMPTOM CORRELATION CHART
                _buildSectionHeader("Symptom Correlation", "Energy vs. Mood"),
                const SizedBox(height: 24),
                _buildSymptomChart(),
                
                const SizedBox(height: 48),

                // 2. CYCLE REGULARITY
                _buildSectionHeader("Cycle Regularity", "Last 6 Months"),
                const SizedBox(height: 24),
                _buildRegularityMetrics(),

                const SizedBox(height: 48),

                // 3. PHASE DISTRIBUTION
                _buildSectionHeader("Phase Distribution", "Average Days"),
                const SizedBox(height: 24),
                _buildPhaseDistribution(),
              ],
            ),
          ),

          // TOP NAV
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: IrmaNavigationBar(
              title: "Health Insights",
              showBackButton: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: IrmaTheme.outfit.copyWith(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(subtitle, style: IrmaTheme.inter.copyWith(color: IrmaTheme.textSub, fontSize: 13)),
      ],
    );
  }

  Widget _buildSymptomChart() {
    return Container(
      height: 200,
      padding: const EdgeInsets.only(right: 16, top: 16),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: const [
                FlSpot(0, 3),
                FlSpot(1, 4),
                FlSpot(2, 2),
                FlSpot(3, 5),
                FlSpot(4, 3),
                FlSpot(5, 4),
              ],
              isCurved: true,
              color: IrmaTheme.ovulation,
              barWidth: 4,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: IrmaTheme.ovulation.withOpacity(0.1),
              ),
            ),
            LineChartBarData(
              spots: const [
                FlSpot(0, 2),
                FlSpot(1, 3),
                FlSpot(2, 4),
                FlSpot(3, 2),
                FlSpot(4, 4),
                FlSpot(5, 3),
              ],
              isCurved: true,
              color: IrmaTheme.menstrual,
              barWidth: 4,
              dotData: FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegularityMetrics() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          IrmaInsightCard(
            title: "Avg. Cycle",
            value: "29 Days",
            icon: Iconsax.timer_1,
            baseColor: IrmaTheme.follicular,
          ),
          const SizedBox(width: 16),
          IrmaInsightCard(
            title: "Variation",
            value: "± 2 Days",
            icon: Iconsax.activity,
            baseColor: IrmaTheme.luteal,
          ),
          const SizedBox(width: 16),
          IrmaInsightCard(
            title: "Period",
            value: "5 Days",
            icon: Iconsax.flash_1,
            baseColor: IrmaTheme.menstrual,
          ),
        ],
      ),
    );
  }


  Widget _buildPhaseDistribution() {
    return Container(
      height: 12,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: IrmaTheme.borderLight,
      ),
      child: Row(
        children: [
          Expanded(flex: 5, child: _smallSegment(IrmaTheme.menstrual)),
          Expanded(flex: 9, child: _smallSegment(IrmaTheme.follicular)),
          Expanded(flex: 2, child: _smallSegment(IrmaTheme.ovulation)),
          Expanded(flex: 12, child: _smallSegment(IrmaTheme.luteal)),
        ],
      ),
    );
  }

  Widget _smallSegment(Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
