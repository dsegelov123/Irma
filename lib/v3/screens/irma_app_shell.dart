import 'package:flutter/material.dart';
import '../widgets/irma_nav_bar.dart';
import '../widgets/irma_bottom_nav.dart';
import '../theme/irma_theme.dart';
import 'dashboard_screen.dart';
import 'cycle_screen.dart';
import 'irma_self_care_screen.dart';
import 'insights_screen.dart';
import 'symptoms_screen.dart';
import 'chat_screen.dart';

class IrmaAppShell extends StatefulWidget {
  const IrmaAppShell({super.key});

  @override
  State<IrmaAppShell> createState() => _IrmaAppShellState();
}

class _IrmaAppShellState extends State<IrmaAppShell> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: IrmaTheme.pureWhite,
      extendBody: true, // Allows the bottom nav to float beautifully
      body: Stack(
        children: [
          // MAIN CONTENT
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            children: const [
              IrmaDashboardScreen(),
              IrmaChatScreen(),
              IrmaInsightsScreen(),
            ],
          ),

          // TOP NAVIGATION BAR (Gospel Immersive Header)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: IrmaNavigationBar(
              title: _getScreenTitle(_currentIndex),
            ),
          ),

          // BOTTOM NAVIGATION (Floating Pill)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: IrmaBottomNav(
                currentIndex: _currentIndex,
                onTap: (index) {
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOutQuart,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getScreenTitle(int index) {
    switch (index) {
      case 0: return "Dashboard";
      case 1: return "Irma AI";
      case 2: return "Insights";
      default: return "Irma";
    }
  }
}

class IrmaPlaceholderScreen extends StatelessWidget {
  final String title;
  const IrmaPlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 300), // Push below the navbar
      alignment: Alignment.topCenter,
      child: Text(
        title,
        style: IrmaTheme.outfit.copyWith(
          fontSize: 24,
          color: IrmaTheme.textSub,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
