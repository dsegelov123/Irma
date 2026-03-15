import 'package:flutter/material.dart';
import '../theme/irma_theme.dart';
import '../widgets/irma_buttons.dart';
import 'auth_selection_screen.dart';

class IrmaOnboardingScreen extends StatefulWidget {
  const IrmaOnboardingScreen({super.key});

  @override
  State<IrmaOnboardingScreen> createState() => _IrmaOnboardingScreenState();
}

class _IrmaOnboardingScreenState extends State<IrmaOnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _slides = [
    OnboardingData(
      title: "Track Your Cycle",
      description: "Understand your body's patterns with precision and privacy.",
      icon: Icons.calendar_today,
    ),
    OnboardingData(
      title: "AI Health Insights",
      description: "Get personalized feedback and patterns detection powered by AI.",
      icon: Icons.auto_awesome,
    ),
    OnboardingData(
      title: "Join the Community",
      description: "Connect with others and share your journey in a safe space.",
      icon: Icons.people_outline,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: IrmaTheme.pureWhite,
      body: SafeArea(
        child: Column(
          children: [
            // SKIP BUTTON
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () => _navigateToAuth(),
                child: Text(
                  "Skip",
                  style: IrmaTheme.inter.copyWith(
                    color: IrmaTheme.textSub,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            // CAROUSEL
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemCount: _slides.length,
                itemBuilder: (context, index) {
                  return OnboardingSlide(data: _slides[index]);
                },
              ),
            ),

            // DOT INDICATORS
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _slides.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: _currentPage == index ? 24 : 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? IrmaTheme.menstrual
                        : IrmaTheme.borderLight,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // PRIMARY BUTTON (Gospel Rectified)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: IrmaPrimaryButton(
                label: _currentPage == _slides.length - 1 ? "Get Started" : "Next",
                onTap: () {
                  if (_currentPage < _slides.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOutQuart,
                    );
                  } else {
                    _navigateToAuth();
                  }
                },
              ),
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _navigateToAuth() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const IrmaAuthSelectionScreen()),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final IconData icon;

  OnboardingData({
    required this.title,
    required this.description,
    required this.icon,
  });
}

class OnboardingSlide extends StatelessWidget {
  final OnboardingData data;

  const OnboardingSlide({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              color: IrmaTheme.menstrual.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              data.icon,
              size: 80,
              color: IrmaTheme.menstrual,
            ),
          ),
          const SizedBox(height: 60),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: IrmaTheme.outfit.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: IrmaTheme.textMain,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: IrmaTheme.inter.copyWith(
              fontSize: 16,
              color: IrmaTheme.textSub,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
