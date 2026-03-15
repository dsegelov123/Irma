import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/irma_theme.dart';
import '../widgets/irma_nav_bar.dart';
import '../widgets/irma_buttons.dart';
import '../models/irma_cycle_data.dart';
import '../providers/irma_state_providers.dart';
import 'irma_app_shell.dart';

class IrmaCycleSetupScreen extends ConsumerStatefulWidget {
  const IrmaCycleSetupScreen({super.key});

  @override
  ConsumerState<IrmaCycleSetupScreen> createState() => _IrmaCycleSetupScreenState();
}

class _IrmaCycleSetupScreenState extends ConsumerState<IrmaCycleSetupScreen> {
  final TextEditingController _lastPeriodController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  double _cycleLength = 28.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: IrmaTheme.pureWhite,
      extendBodyBehindAppBar: true,
      appBar: const IrmaNavigationBar(
        title: "Cycle Setup",
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 80, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your Cycle History",
              style: IrmaTheme.outfit.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Tell us about your rhythm so we can start predicting your next phase.",
              style: IrmaTheme.inter.copyWith(color: IrmaTheme.textSub),
            ),
            const SizedBox(height: 40),

            // LAST PERIOD DATE
            Text(
              "When did your last period start?",
              style: IrmaTheme.inter.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: IrmaTheme.textMain,
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() {
                    _selectedDate = date;
                    _lastPeriodController.text = "${date.day} / ${date.month} / ${date.year}";
                  });
                }
              },
              child: Container(
                height: 52, // Gospel Input Height
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(IrmaTheme.radiusAction),
                  border: Border.all(color: IrmaTheme.borderLight),
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  _lastPeriodController.text.isEmpty
                      ? "Select Date"
                      : _lastPeriodController.text,
                  style: IrmaTheme.inter.copyWith(
                    color: _lastPeriodController.text.isEmpty
                        ? IrmaTheme.textSub
                        : IrmaTheme.textMain,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // CYCLE LENGTH SLIDER (Using a slider for premium feel)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Average Cycle Length",
                  style: IrmaTheme.inter.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: IrmaTheme.textMain,
                  ),
                ),
                Text(
                  "${_cycleLength.toInt()} Days",
                  style: IrmaTheme.outfit.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: IrmaTheme.menstrual,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Slider(
              value: _cycleLength,
              min: 21,
              max: 35,
              divisions: 14,
              activeColor: IrmaTheme.menstrual,
              inactiveColor: IrmaTheme.borderLight,
              onChanged: (val) {
                setState(() => _cycleLength = val);
              },
            ),

            const SizedBox(height: 60),

            IrmaPrimaryButton(
              label: "Finish Setup",
              onTap: () async {
                final cycleData = IrmaCycleData(
                  lastPeriodDate: _selectedDate,
                  avgCycleLength: _cycleLength.toInt(),
                );
                
                await ref.read(irmaCycleDataProvider.notifier).updateData(cycleData);

                if (mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const IrmaAppShell()),
                    (route) => false,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
