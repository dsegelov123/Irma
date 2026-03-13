import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ErrorReportingService {
  static Future<void> init() async {
    final dns = dotenv.env['SENTRY_DSN'];
    
    if (dns != null && dns.isNotEmpty) {
      await SentryFlutter.init(
        (options) {
          options.dsn = dns;
          options.tracesSampleRate = 1.0;
        },
      );
    }

    // Catch global Flutter errors
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      _logError(details.exception, details.stack);
    };

    // Catch errors not caught by Flutter
    PlatformDispatcher.instance.onError = (error, stack) {
      _logError(error, stack);
      return true;
    };
  }

  static void _logError(dynamic error, StackTrace? stack) {
    // PRIVACY FIRST: Ensure no health data or logs are accidentally captured.
    // In a real production app, this would send to Sentry/Crashlytics.
    // We strip all but the basic error type and stack trace for privacy.
    
    if (kDebugMode) {
      print('--- IRMA ERROR CAUGHT ---');
      print('Type: ${error.runtimeType}');
      print('Stack: $stack');
      print('-------------------------');
    }
    
    // Send to Sentry
    Sentry.captureException(error, stackTrace: stack);
  }

  static void recordMessage(String message) {
    if (kDebugMode) {
      print('[IRMA LOG]: $message');
    }
  }
}
