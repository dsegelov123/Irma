import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../theme/irma_theme.dart';
import '../widgets/irma_cycle_ring.dart';
import '../widgets/irma_cards.dart';
import '../providers/irma_state_providers.dart';
import '../services/irma_cycle_engine.dart';
import '../models/irma_cycle_data.dart';
import 'symptoms_screen.dart';
import 'partner_screen.dart';
import 'settings_screen.dart';

class IrmaDashboardScreen extends ConsumerWidget {
  const IrmaDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cycleState = ref.watch(irmaCycleStateProvider);
    final aiInsight = ref.watch(irmaAIInsightProvider);
    
    // Default fallback if no data yet (e.g. during dev or fresh install)
    final currentDay = cycleState?.currentDay ?? 1;
    final totalDays = cycleState?.totalDays ?? 28;
    final phase = cycleState?.phase ?? IrmaCyclePhase.menstrual;
    
    final wisdom = aiInsight.when(
      data: (data) => data,
      loading: () => "Auntie is thinking...",
      error: (err, _) => cycleState?.phaseDescription ?? "Auntie is reflecting on your data...",
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 320, bottom: 120), // Padding for nav bars
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
          
          const SizedBox(height: 48),

          // 2. INSIGHT CARDS (Horizontal Scroll)
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
            height: 196,
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

          // 3. MENTAL WELLNESS / WISDOM CARD (Research-Driven)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: IrmaDashboardCard(
              title: "Daily Wisdom",
              subtitle: "Phase-specific mental wellness",
              onTap: () {},
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    wisdom,
                    style: IrmaTheme.inter.copyWith(
                      color: IrmaTheme.textMain,
                      height: 1.5,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildMiniBadge("Energy: High", IrmaTheme.ovulation),
                      const SizedBox(width: 8),
                      _buildMiniBadge("Self-care: Social", IrmaTheme.follicular),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: IrmaDashboardCard(
              title: "Partner Sync",
              subtitle: "Connect with a partner",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const IrmaPartnerScreen()),
                );
              },
              content: Text(
                "Share your cycle with a partner for better support.",
                style: IrmaTheme.inter.copyWith(color: IrmaTheme.textSub),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // 4. SYMPTOMS QUICK LOG
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: IrmaDashboardCard(
              title: "How are you feeling?",
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

  Widget _buildMiniBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: IrmaTheme.inter.copyWith(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
