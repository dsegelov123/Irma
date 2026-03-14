import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'v3/screens/onboarding_screen.dart';
import 'v3/screens/irma_app_shell.dart';
import 'v3/widgets/irma_lock_screen.dart';
import 'v3/services/irma_security_service.dart';
import 'v3/theme/irma_theme.dart';
import 'v3/models/irma_cycle_data.dart';
import 'v3/models/irma_daily_log.dart';
import 'v3/models/irma_partner.dart';
import 'v3/providers/irma_state_providers.dart';
import 'v3/screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );

  // Initialize Hive for local, privacy-first storage
  await Hive.initFlutter();
  
  // Register v3 Hive Adapters
  Hive.registerAdapter(IrmaCycleDataAdapter());
  Hive.registerAdapter(IrmaCyclePhaseAdapter());
  Hive.registerAdapter(IrmaDailyLogAdapter());
  Hive.registerAdapter(IrmaPartnerAdapter());
  Hive.registerAdapter(PartnerStatusAdapter());
  
  // Open v3 Boxes
  await Hive.openBox<IrmaCycleData>('irmaCycleBox');
  await Hive.openBox<IrmaDailyLog>('irmaDailyLogBox');
  await Hive.openBox<IrmaPartner>('irmaPartnerBox');

  runApp(const ProviderScope(child: MyApp()));
}

// Renamed IrmaApp to MyApp and updated its structure
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticated = ref.watch(irmaAuthenticatedProvider);
    final lockEnabled = ref.watch(irmaLockEnabledProvider);
    final cycleData = ref.watch(irmaCycleDataProvider);
    
    // Simple logic: if cycle data exists, user is onboarded
    final isOnboarded = cycleData != null;

    Widget home;
    if (!isOnboarded) {
      home = const IrmaOnboardingScreen();
    } else if (lockEnabled && !isAuthenticated) {
      home = const IrmaLockScreen();
    } else {
      home = const IrmaAppShell();
    }

    return MaterialApp(
      title: 'Irma - Auntie\'s Wisdom',
      debugShowCheckedModeBanner: false,
      theme: IrmaTheme.lightTheme,
      home: home,
      // Legacy routes disabled for v3 build
      onGenerateRoute: (settings) => null, 
    );
  }
}
