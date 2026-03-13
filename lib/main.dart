import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/user_profile.dart';
import 'models/daily_log.dart';
import 'models/cycle_data.dart';
import 'models/sharing_settings.dart';
import 'providers/app_state_providers.dart';
import 'screens/dashboard_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/analytics_dashboard.dart';
import 'screens/wellness_integration.dart';
import 'screens/settings_screen.dart';
import 'screens/sharing_settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive for local, privacy-first storage
  await Hive.initFlutter();
  
  // Register Adapters
  Hive.registerAdapter(UserProfileAdapter());
  Hive.registerAdapter(DailyLogAdapter());
  Hive.registerAdapter(CycleDataAdapter());
  Hive.registerAdapter(SharingSettingsAdapter());
  
  // Open Boxes
  await Hive.openBox<UserProfile>('userProfileBox');
  await Hive.openBox<DailyLog>('dailyLogBox');
  await Hive.openBox<CycleData>('cycleDataBox');

  runApp(const ProviderScope(child: IrmaApp()));
}

class IrmaApp extends ConsumerWidget {
  const IrmaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);
    final isInitialized = ref.watch(appInitializedProvider);

    return MaterialApp(
      title: 'Irma - Auntie\'s Wisdom',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF5E7E), // Menstrual Pink / Primary
          background: const Color(0xFFF7F6F6),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Inter',
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      home: isInitialized.when(
        data: (_) => userProfile == null ? const OnboardingScreen() : const DashboardScreen(),
        loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (err, stack) => Scaffold(body: Center(child: Text('Error: $err'))),
      ),
      routes: {
        '/dashboard': (context) => const DashboardScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/analytics': (context) => const AnalyticsDashboard(),
        '/wellness': (context) => const WellnessIntegration(currentPhase: 'Tracking...'),
        '/settings': (context) => const SettingsScreen(),
        '/sharing': (context) => const SharingSettingsScreen(),
      },
    );
  }
}
