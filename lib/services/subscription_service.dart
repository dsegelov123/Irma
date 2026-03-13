import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class SubscriptionService {
  // Replace with actual RevenueCat API Keys
  static const String _appleApiKey = 'appl_YOUR_API_KEY_HERE';
  static const String _googleApiKey = 'goog_YOUR_API_KEY_HERE';

  static Future<void> init() async {
    await Purchases.setLogLevel(LogLevel.debug);

    PurchasesConfiguration? configuration;
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      configuration = PurchasesConfiguration(_appleApiKey);
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      configuration = PurchasesConfiguration(_googleApiKey);
    }

    if (configuration != null) {
      await Purchases.configure(configuration);
    }
  }

  /// Checks if the current user has an active premium subscription
  static Future<bool> isPremium() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      // "premium" should match the entitlement ID defined in RevenueCat dashboard
      return customerInfo.entitlements.all['premium']?.isActive ?? false;
    } catch (e) {
      debugPrint('Failed to check premium status: $e');
      return false;
    }
  }

  /// Fetches available subscription products (e.g. Monthly, Yearly)
  static Future<List<Package>> getOfferings() async {
    try {
      final offerings = await Purchases.getOfferings();
      if (offerings.current != null) {
        return offerings.current!.availablePackages;
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching offerings: $e');
      return [];
    }
  }

  /// Initiates the purchase flow for a specific package
  static Future<bool> purchasePackage(Package package) async {
    try {
      final result = await Purchases.purchasePackage(package);
      return result.customerInfo.entitlements.all['premium']?.isActive ?? false;
    } catch (e) {
      debugPrint('Purchase failed: $e');
      return false;
    }
  }
}
