import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../theme/irma_theme.dart';
import '../services/irma_security_service.dart';

class IrmaLockScreen extends ConsumerWidget {
  const IrmaLockScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: IrmaTheme.primaryGradient,
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const Icon(Iconsax.lock, color: IrmaTheme.pureWhite, size: 80),
              const SizedBox(height: 40),
              Text(
                "Irma is Locked",
                style: IrmaTheme.outfit.copyWith(
                  color: IrmaTheme.pureWhite,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Unlock to access your cycle history.",
                style: IrmaTheme.inter.copyWith(color: IrmaTheme.pureWhite.withOpacity(0.8)),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: GestureDetector(
                  onTap: () async {
                    final didAuth = await ref.read(irmaSecurityServiceProvider).authenticate();
                    if (didAuth) {
                      ref.read(irmaAuthenticatedProvider.notifier).state = true;
                    }
                  },
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: IrmaTheme.pureWhite,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Unlock Irma",
                      style: IrmaTheme.outfit.copyWith(
                        color: IrmaTheme.menstrual,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () {
                  // Logic to log out or exit app
                },
                child: Text(
                  "Switch Account",
                  style: IrmaTheme.inter.copyWith(color: IrmaTheme.pureWhite),
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
