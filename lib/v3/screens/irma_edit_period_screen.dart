import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/irma_theme.dart';
import '../widgets/irma_nav_bar.dart';
import '../widgets/irma_buttons.dart';
import '../models/irma_cycle_data.dart';
import '../providers/irma_state_providers.dart';

class IrmaEditPeriodScreen extends ConsumerStatefulWidget {
  const IrmaEditPeriodScreen({super.key});

  @override
  ConsumerState<IrmaEditPeriodScreen> createState() => _IrmaEditPeriodScreenState();
}

class _IrmaEditPeriodScreenState extends ConsumerState<IrmaEditPeriodScreen> {
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _dateController = TextEditingController();
  double _cycleLength = 28.0;
  double _periodLength = 5.0;

  @override
  void initState() {
    super.initState();
    // Load existing cycle data if available
    final currentData = ref.read(irmaCycleDataProvider);
    if (currentData != null) {
      _selectedDate = currentData.lastPeriodDate;
      _cycleLength = currentData.avgCycleLength.toDouble();
      _periodLength = currentData.avgPeriodLength.toDouble();
      _dateController.text = "${_selectedDate.day} / ${_selectedDate.month} / ${_selectedDate.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: IrmaTheme.pureWhite,
      extendBodyBehindAppBar: true,
      appBar: const IrmaNavigationBar(
        title: "Edit Period",
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 80, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Refine Your Rhythm",
              style: IrmaTheme.outfit.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Keeping your period data accurate helps Auntie provide better insights.",
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
                  initialDate: _selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() {
                    _selectedDate = date;
                    _dateController.text = "${date.day} / ${date.month} / ${date.year}";
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
                  _dateController.text,
                  style: IrmaTheme.inter.copyWith(color: IrmaTheme.textMain),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // CYCLE LENGTH SLIDER
            _buildSlider(
              label: "Average Cycle Length",
              value: _cycleLength,
              min: 21,
              max: 35,
              onChanged: (val) => setState(() => _cycleLength = val),
              unit: "Days",
            ),

            const SizedBox(height: 32),

            // PERIOD LENGTH SLIDER
            _buildSlider(
              label: "Average Period Length",
              value: _periodLength,
              min: 2,
              max: 10,
              onChanged: (val) => setState(() => _periodLength = val),
              unit: "Days",
            ),

            const SizedBox(height: 60),

            IrmaPrimaryButton(
              label: "Save Details",
              onTap: () async {
                final cycleData = IrmaCycleData(
                  lastPeriodDate: _selectedDate,
                  avgCycleLength: _cycleLength.toInt(),
                  avgPeriodLength: _periodLength.toInt(),
                );
                
                await ref.read(irmaCycleDataProvider.notifier).updateData(cycleData);

                if (mounted) {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
    required String unit,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: IrmaTheme.inter.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: IrmaTheme.textMain,
              ),
            ),
            Text(
              "${value.toInt()} $unit",
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
          value: value,
          min: min,
          max: max,
          divisions: (max - min).toInt(),
          activeColor: IrmaTheme.menstrual,
          inactiveColor: IrmaTheme.borderLight,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
