import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../theme/irma_theme.dart';
import '../widgets/irma_cycle_ring.dart';
import '../widgets/irma_cards.dart';
import '../providers/irma_state_providers.dart';
import '../services/irma_cycle_engine.dart';
import '../models/irma_cycle_data.dart';
import '../widgets/irma_buttons.dart';
import 'symptoms_screen.dart';
import 'settings_screen.dart';
import 'irma_edit_period_screen.dart';

class IrmaDashboardScreen extends ConsumerWidget {
  const IrmaDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cycleState = ref.watch(irmaCycleStateProvider);
    
    // Default fallback if no data yet (e.g. during dev or fresh install)
    final currentDay = cycleState?.currentDay ?? 1;
    final totalDays = cycleState?.totalDays ?? 28;
    final phase = cycleState?.phase ?? IrmaCyclePhase.menstrual;
    

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 80, bottom: 120), // Standard Gospel Padding for 40px nav
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. CYCLE RING SECTION
          Center(
            child: IrmaCycleRing(
              currentDay: currentDay,
              totalDays: totalDays,
              phase: phase,
            ),
          ),
          
          const SizedBox(height: 32),

          // 2. LOG PERIOD ACTION (Gospel Mandated)
          Center(
            child: IrmaPrimaryButton(
              label: "Log Period",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const IrmaEditPeriodScreen(),
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: 48),

          // 3. INSIGHT CARDS (Gospel Daily Progress)
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Text(
              "Daily Progress",
              style: IrmaTheme.outfit.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: IrmaTheme.textMain,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 145, // EXACT Gospel Height for Insight Cards
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: const [
                IrmaInsightCard(
                  title: "Sleep",
                  value: "7h 20m",
                  icon: Iconsax.moon,
                  baseColor: IrmaTheme.luteal,
                ),
                SizedBox(width: 16),
                IrmaInsightCard(
                  title: "Water",
                  value: "1.8 Liters",
                  icon: Iconsax.mask,
                  baseColor: IrmaTheme.ovulation,
                ),
                SizedBox(width: 16),
                IrmaInsightCard(
                  title: "Movements",
                  value: "5,432 Steps",
                  icon: Iconsax.ranking,
                  baseColor: IrmaTheme.follicular,
                ),
              ],
            ),
          ),

          const SizedBox(height: 48),

          // 4. SYMPTOMS QUICK LOG
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: IrmaDashboardCard(
              title: "Log Symptoms",
              subtitle: "How are you feeling?",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => IrmaSymptomsScreen(date: DateTime.now()),
                  ),
                );
              },
              content: Row(
                children: [
                  const Icon(Iconsax.heart5, color: IrmaTheme.menstrual, size: 32),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      "Log your physical and emotional symptoms for better AI patterns.",
                      style: IrmaTheme.inter.copyWith(color: IrmaTheme.textSub),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}
