import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../theme/irma_theme.dart';
import '../widgets/irma_nav_bar.dart';
import '../widgets/irma_exercise_player.dart';

class IrmaProgram {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final List<String> itemsNeeded;
  final IconData icon;
  final Color color;
  final int totalMinutes;

  IrmaProgram({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.itemsNeeded,
    required this.icon,
    required this.color,
    required this.totalMinutes,
  });
}

class IrmaProgramDetailsScreen extends StatelessWidget {
  final IrmaProgram program;

  const IrmaProgramDetailsScreen({super.key, required this.program});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: IrmaTheme.pureWhite,
      body: Stack(
        children: [
          // 1. SCROLLABLE CONTENT
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 120), // Spacing for navbar
                
                // PROGRAM ICON & HEADER
                Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: program.color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(program.icon, color: program.color, size: 48),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    program.title,
                    style: IrmaTheme.outfit.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: IrmaTheme.textMain,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    program.subtitle,
                    style: IrmaTheme.inter.copyWith(
                      fontSize: 16,
                      color: IrmaTheme.textSub,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // DESCRIPTION SECTION
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Description",
                        style: IrmaTheme.outfit.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: IrmaTheme.textMain,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        program.description,
                        style: IrmaTheme.inter.copyWith(
                          fontSize: 16,
                          color: IrmaTheme.textSub,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // ITEMS NEEDED SECTION (Mockup Two Feature)
                if (program.itemsNeeded.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "You'll Need",
                          style: IrmaTheme.outfit.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: IrmaTheme.textMain,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 140,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: program.itemsNeeded.length,
                            itemBuilder: (context, index) {
                              return _buildItemCard(program.itemsNeeded[index]);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                
                const SizedBox(height: 140), // Spacer for fixed button
              ],
            ),
          ),

          // 2. FIXED BOTTOM BUTTON ("Let's Start")
          Positioned(
            bottom: 40,
            left: 24,
            right: 24,
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                gradient: IrmaTheme.primaryGradient,
                borderRadius: BorderRadius.circular(IrmaTheme.radiusAction),
                boxShadow: [
                  BoxShadow(
                    color: IrmaTheme.menstrual.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IrmaExercisePlayer(
                        programTitle: program.title,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(IrmaTheme.radiusAction),
                  ),
                ),
                child: Text(
                  "Let's Start",
                  style: IrmaTheme.outfit.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: IrmaTheme.pureWhite,
                  ),
                ),
              ),
            ),
          ),

          // TOP NAV
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: IrmaNavigationBar(
              title: "Program Details",
              showBackButton: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(String item) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: IrmaTheme.pureWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: IrmaTheme.borderLight),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: IrmaTheme.borderLight.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Iconsax.box, color: IrmaTheme.textSub, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            item,
            textAlign: TextAlign.center,
            style: IrmaTheme.inter.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: IrmaTheme.textMain,
            ),
          ),
        ],
      ),
    );
  }
}
