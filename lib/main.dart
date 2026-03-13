import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'models/user_profile.dart';
import 'models/daily_log.dart';
import 'models/cycle_data.dart';
import 'models/sharing_settings.dart';
import 'models/notification_settings.dart';
import 'theme/app_colors.dart';
import 'providers/app_state_providers.dart';
import 'screens/dashboard_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/analytics_dashboard.dart';
import 'screens/wellness_integration.dart';
import 'screens/settings_screen.dart';
import 'screens/sharing_settings_screen.dart';
import 'screens/notification_settings_screen.dart';
import 'screens/privacy_center_screen.dart';
import 'services/notification_service.dart';
import 'services/error_reporting_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Error Reporting (Sentry)
  await ErrorReportingService.init();
  
  // Initialize Hive for local, privacy-first storage
  await Hive.initFlutter();
  await NotificationService.init();
  
  // Register Adapters
  Hive.registerAdapter(UserProfileAdapter());
  Hive.registerAdapter(DailyLogAdapter());
  Hive.registerAdapter(CycleDataAdapter());
  Hive.registerAdapter(SharingSettingsAdapter());
  Hive.registerAdapter(NotificationSettingsAdapter());
  Hive.registerAdapter(NotificationFrequencyAdapter());
  
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
          surface: const Color(0xFFF7F6F6),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme(
          Theme.of(context).textTheme,
        ).copyWith(
          displayLarge: GoogleFonts.lufga(
            textStyle: Theme.of(context).textTheme.displayLarge,
            fontWeight: FontWeight.bold,
          ),
          headlineMedium: GoogleFonts.lufga(
            textStyle: Theme.of(context).textTheme.headlineMedium,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: GoogleFonts.lufga(
            textStyle: Theme.of(context).textTheme.titleLarge,
            fontWeight: FontWeight.w600,
          ),
        ),
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
        '/notifications': (context) => const NotificationSettingsScreen(),
        '/privacy-center': (context) => const PrivacyCenterScreen(),
      },
    );
  }
}
