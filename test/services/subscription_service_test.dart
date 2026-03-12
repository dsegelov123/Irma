import 'package:flutter_test/flutter_test.dart';
import 'package:irma/services/subscription_service.dart';
import 'package:flutter/services.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Subscription Service Tests', () {
    test('isPremium defaults to false when uninitialized/mocked', () async {
      // Because purchases_flutter uses MethodChannels, running this in a unit test
      // without native mocks will throw a MissingPluginException, which our
      // try-catch block in SubscriptionService will catch and return false.
      
      final isPremium = await SubscriptionService.isPremium();
      expect(isPremium, false);
    });

    test('getOfferings returns empty list on failure', () async {
      final offerings = await SubscriptionService.getOfferings();
      expect(offerings, isEmpty);
    });
  });
}
