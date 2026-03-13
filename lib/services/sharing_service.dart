import 'dart:math';

class SharingService {
  /// Generates a random 6-digit alphanumeric code for pairing
  static String generateSharingCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'; // Removed ambiguous chars like 0, O, 1, I
    final rnd = Random();
    return String.fromCharCodes(Iterable.generate(
      6, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))
    ));
  }

  /// In a real app, this would push pairing info to a secure backend.
  /// For this POC, we'll simulate the pairing success.
  static Future<bool> simulatePairing(String code) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}
