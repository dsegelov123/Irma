import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/irma_theme.dart';
import '../widgets/irma_month_calendar.dart';
import '../providers/irma_state_providers.dart';
import 'symptoms_screen.dart';

class IrmaCycleScreen extends ConsumerWidget {
  const IrmaCycleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cycleData = ref.watch(irmaCycleDataProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 80, bottom: 120),
      child: Column(
        children: [
          // 1. MONTH CALENDAR
          if (cycleData != null)
            Center(
              child: IrmaMonthCalendar(
                cycleData: cycleData,
                onDateSelected: (date) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IrmaSymptomsScreen(date: date),
                    ),
                  );
                },
              ),
            )
          else
            const Padding(
              padding: EdgeInsets.all(48),
              child: Text("Please complete cycle setup in your profile."),
            ),

          const SizedBox(height: 32),

          // 2. LEGEND / INFO
          Center(
            child: Container(
              width: 345, // Gospel Standard Width
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: IrmaTheme.pureWhite,
                borderRadius: BorderRadius.circular(IrmaTheme.radiusCard), // Gospel Standard Radius
                border: Border.all(color: IrmaTheme.borderLight),
                boxShadow: [
                  BoxShadow(
                    color: IrmaTheme.pureBlack.withOpacity(0.04),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Cycle Legend",
                    style: IrmaTheme.outfit.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: IrmaTheme.textMain,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildLegendItem("Menstrual", IrmaTheme.menstrual),
                  const SizedBox(height: 12),
                  _buildLegendItem("Follicular", IrmaTheme.follicular),
                  const SizedBox(height: 12),
                  _buildLegendItem("Ovulation", IrmaTheme.ovulation),
                  const SizedBox(height: 12),
                  _buildLegendItem("Luteal", IrmaTheme.luteal),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: IrmaTheme.inter.copyWith(
            fontSize: 14,
            color: IrmaTheme.textSub,
          ),
        ),
      ],
    );
  }
}
