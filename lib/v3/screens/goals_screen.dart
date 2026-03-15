import 'package:flutter/material.dart';
import '../theme/irma_theme.dart';
import '../widgets/irma_nav_bar.dart';
import 'cycle_setup_screen.dart';
import '../widgets/irma_buttons.dart';

class IrmaChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const IrmaChip({
    super.key,
    required this.label,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? IrmaTheme.menstrual : IrmaTheme.pureWhite,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: isSelected ? IrmaTheme.menstrual : IrmaTheme.borderLight,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: IrmaTheme.menstrual.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Text(
          label,
          style: IrmaTheme.inter.copyWith(
            color: isSelected ? IrmaTheme.pureWhite : IrmaTheme.textMain,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class IrmaGoalsScreen extends StatefulWidget {
  const IrmaGoalsScreen({super.key});

  @override
  State<IrmaGoalsScreen> createState() => _IrmaGoalsScreenState();
}

class _IrmaGoalsScreenState extends State<IrmaGoalsScreen> {
  final List<String> _allGoals = [
    "Reduce Stress",
    "Better Sleep",
    "Track Cycle",
    "Mental Wellness",
    "Fitness Goals",
    "Skin Health",
    "Energy Boost",
    "Nutritional Plan",
  ];

  final Set<String> _selectedGoals = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: IrmaTheme.pureWhite,
      extendBodyBehindAppBar: true,
      appBar: const IrmaNavigationBar(
        title: "Your Goals",
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 80, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "What are your priorities?",
              style: IrmaTheme.outfit.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Select at least one goal to help us tailor your experience.",
              style: IrmaTheme.inter.copyWith(color: IrmaTheme.textSub),
            ),
            const SizedBox(height: 32),

            // GOALS GRID
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _allGoals.map((goal) {
                final isSelected = _selectedGoals.contains(goal);
                return IrmaChip(
                  label: goal,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedGoals.remove(goal);
                      } else {
                        _selectedGoals.add(goal);
                      }
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 60),

            IrmaPrimaryButton(
              label: "Continue",
              onTap: _selectedGoals.isEmpty ? () {} : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const IrmaCycleSetupScreen()),
                );
              },
              isLoading: false, // Could also use a 'disabled' state but PrimaryButton doesn't have it yet, using empty callback for now to match logic
            ),
          ],
        ),
      ),
    );
  }
}
