import 'package:local_auth/local_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final irmaSecurityServiceProvider = Provider((ref) => IrmaSecurityService());

final irmaAuthenticatedProvider = StateProvider<bool>((ref) => false);

class IrmaSecurityService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> isBiometricAvailable() async {
    final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
    final bool canAuthenticate = canAuthenticateWithBiometrics || await _auth.isDeviceSupported();
    return canAuthenticate;
  }

  Future<bool> authenticate() async {
    try {
      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: 'Please authenticate to unlock Irma',
      );
      return didAuthenticate;
    } catch (e) {
      return false;
    }
  }
}
