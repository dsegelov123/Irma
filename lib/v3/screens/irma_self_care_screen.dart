import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../theme/irma_theme.dart';
import '../widgets/irma_nav_bar.dart';
import 'irma_program_details_screen.dart';

class IrmaSelfCareScreen extends ConsumerWidget {
  const IrmaSelfCareScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: IrmaTheme.pureWhite,
      body: Stack(
        children: [
          // 1. SCROLLABLE CONTENT
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 320), // Top nav spacer (Gospel Immersive)
                
                // HEADER TITLE
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    "What do you want to\nlearn today?",
                    style: IrmaTheme.outfit.copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: IrmaTheme.textMain,
                      height: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // PROGRAM TILES GRID/LIST
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      _buildProgramTile(
                        context,
                        title: "Cramps",
                        subtitle: "Menstrual cramps relief",
                        icon: Iconsax.health,
                        color: IrmaTheme.menstrual,
                      ),
                      const SizedBox(height: 16),
                      _buildProgramTile(
                        context,
                        title: "Strength",
                        subtitle: "7-day strength program",
                        icon: Iconsax.fatrows,
                        color: IrmaTheme.follicular,
                      ),
                      const SizedBox(height: 16),
                      _buildProgramTile(
                        context,
                        title: "Meditation",
                        subtitle: "Calm your mind",
                        icon: Iconsax.mask,
                        color: IrmaTheme.ovulatory,
                      ),
                      const SizedBox(height: 16),
                      _buildProgramTile(
                        context,
                        title: "Skin Care",
                        subtitle: "Facial & Skin health",
                        icon: Iconsax.magic_mirror,
                        color: IrmaTheme.luteal,
                      ),
                      const SizedBox(height: 120), // Bottom nav spacer
                    ],
                  ),
                ),
              ],
            ),
          ),

          // TOP NAV
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: IrmaNavigationBar(
              title: "Self Care",
              showBackButton: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgramTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        final program = IrmaProgram(
          id: title.toLowerCase(),
          title: title,
          subtitle: subtitle,
          description: _getDummyDescription(title),
          itemsNeeded: _getDummyItems(title),
          icon: icon,
          color: color,
          totalMinutes: 10,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IrmaProgramDetailsScreen(program: program),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        height: 100, // Matching Figma mockup tile height
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: IrmaTheme.pureWhite,
          borderRadius: BorderRadius.circular(18), // Gospel Rule for Program Tiles
          border: Border.all(color: IrmaTheme.borderLight),
          boxShadow: [
            BoxShadow(
              color: IrmaTheme.pureBlack.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: IrmaTheme.outfit.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: IrmaTheme.textMain,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: IrmaTheme.inter.copyWith(
                      fontSize: 14,
                      color: IrmaTheme.textSub,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Iconsax.arrow_right_3, color: IrmaTheme.textSub, size: 20),
          ],
        ),
      ),
    );
  }

  String _getDummyDescription(String title) {
    switch (title) {
      case "Cramps":
        return "A guided session focusing on light movements and breathing techniques specifically designed to alleviate menstrual cramp discomfort and promote pelvic relaxation.";
      case "Strength":
        return "Build core stability and gentle muscle tone through a series of safe, low-impact exercises tailored for your current cycle phase.";
      case "Meditation":
        return "Find your inner calm with this guided mindfulness session. Perfect for reducing stress and improving hormonal balance through deep relaxation.";
      default:
        return "A specialized wellness program designed to support your body's needs during this phase of your cycle.";
    }
  }

  List<String> _getDummyItems(String title) {
    if (title == "Cramps") return ["Yoga Mat", "Hot Water Bottle", "Comfortable Clothes"];
    if (title == "Strength") return ["Yoga Mat", "Resistance Band", "Water Bottle"];
    if (title == "Meditation") return ["Quiet Space", "Cushion", "Headphones"];
    return ["Yoga Mat", "Water Bottle"];
  }
}
