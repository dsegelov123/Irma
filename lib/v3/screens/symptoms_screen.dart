import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../theme/irma_theme.dart';
import '../widgets/irma_nav_bar.dart';
import '../widgets/irma_symptom_card.dart';
import '../models/irma_daily_log.dart';
import '../providers/irma_state_providers.dart';

// IrmaSymptomsScreen uses the global irmaDailyLogProvider from irma_state_providers.dart

class IrmaSymptomsScreen extends ConsumerWidget {
  final DateTime date;
  const IrmaSymptomsScreen({super.key, required this.date});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final log = ref.watch(irmaDailyLogProvider(date));

    return Scaffold(
      backgroundColor: IrmaTheme.pureWhite,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 140, bottom: 40, left: 24, right: 24),
            child: Column(
              children: [
                IrmaSymptomCard(
                  title: "Symptoms",
                  value: log?.symptoms.join(", "),
                  icon: Iconsax.heart,
                  baseColor: IrmaTheme.menstrual,
                  isEmpty: log?.symptoms.isEmpty ?? true,
                  onTap: () => _showSymptomsPicker(context, ref, log),
                ),
                const SizedBox(height: 16),
                IrmaSymptomCard(
                  title: "Water Intake",
                  value: log?.waterLiters != null ? "${log!.waterLiters} L" : null,
                  icon: Iconsax.mask,
                  baseColor: IrmaTheme.ovulation,
                  isEmpty: log?.waterLiters == null,
                  onTap: () => _showWaterPicker(context, ref, log),
                ),
                const SizedBox(height: 16),
                IrmaSymptomCard(
                  title: "Weight",
                  value: log?.weightKg != null ? "${log!.weightKg} Kg" : null,
                  icon: Iconsax.ranking,
                  baseColor: IrmaTheme.follicular,
                  isEmpty: log?.weightKg == null,
                  onTap: () => _showWeightPicker(context, ref, log),
                ),
                const SizedBox(height: 16),
                IrmaSymptomCard(
                  title: "Notes",
                  value: log?.note,
                  icon: Iconsax.edit,
                  baseColor: IrmaTheme.luteal,
                  isEmpty: log?.note == null || log!.note!.isEmpty,
                  onTap: () => _showNotePicker(context, ref, log),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: IrmaNavigationBar(
              title: "Daily Log",
              showBackButton: true,
            ),
          ),
        ],
      ),
    );
  }

  void _showSymptomsPicker(BuildContext context, WidgetRef ref, IrmaDailyLog? log) {
    final options = ["Cramps", "Headache", "Mood Swings", "Bloating", "Acne", "Cravings"];
    final currentSymptoms = log?.symptoms ?? [];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Select Symptoms", style: IrmaTheme.outfit.copyWith(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: options.map((symptom) {
                  final isSelected = currentSymptoms.contains(symptom);
                  return FilterChip(
                    label: Text(symptom),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        currentSymptoms.add(symptom);
                      } else {
                        currentSymptoms.remove(symptom);
                      }
                      ref.read(irmaDailyLogProvider(date).notifier).updateLog(symptoms: currentSymptoms);
                      setModalState(() {});
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  void _showWaterPicker(BuildContext context, WidgetRef ref, IrmaDailyLog? log) {
    // Simplified picker for example
    ref.read(irmaDailyLogProvider(date).notifier).updateLog(water: 2.0);
  }

  void _showWeightPicker(BuildContext context, WidgetRef ref, IrmaDailyLog? log) {
    ref.read(irmaDailyLogProvider(date).notifier).updateLog(weight: 65.5);
  }

  void _showNotePicker(BuildContext context, WidgetRef ref, IrmaDailyLog? log) {
    ref.read(irmaDailyLogProvider(date).notifier).updateLog(note: "Feeling good today!");
  }
}
