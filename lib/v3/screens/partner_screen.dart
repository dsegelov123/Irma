import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../theme/irma_theme.dart';
import '../widgets/irma_nav_bar.dart';
import '../widgets/irma_status_box.dart';
import '../models/irma_partner.dart';
import '../services/irma_partner_service.dart';

class IrmaPartnerScreen extends ConsumerWidget {
  const IrmaPartnerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final partner = ref.watch(irmaPartnerProvider);

    return Scaffold(
      backgroundColor: IrmaTheme.pureWhite,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 320, bottom: 40, left: 24, right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. HEADER INFO
                Text(
                  "Partner Sync",
                  style: IrmaTheme.outfit.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: IrmaTheme.textMain,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Invite a partner to share your cycle journey and mental wellness insights.",
                  style: IrmaTheme.inter.copyWith(
                    fontSize: 15,
                    color: IrmaTheme.textSub,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 40),

                // 2. CONNECTION AREA
                if (partner == null)
                  _buildEmptyState(context, ref)
                else if (partner.status == PartnerStatus.pending)
                  _buildPendingState(context, ref, partner)
                else if (partner.status == PartnerStatus.connected)
                  _buildConnectedState(context, ref, partner),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: IrmaNavigationBar(
              title: "Partner Management",
              showBackButton: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: IrmaTheme.follicular.withOpacity(0.05),
            borderRadius: BorderRadius.circular(IrmaTheme.radiusCard),
            border: Border.all(color: IrmaTheme.follicular.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              const Icon(Iconsax.user_add, color: IrmaTheme.follicular, size: 48),
              const SizedBox(height: 20),
              Text(
                "No active partners",
                style: IrmaTheme.outfit.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () => _showAddPartnerDialog(context, ref),
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: IrmaTheme.follicular,
                    borderRadius: BorderRadius.circular(IrmaTheme.radiusAction),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Invite Partner",
                    style: IrmaTheme.outfit.copyWith(
                      color: IrmaTheme.pureWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPendingState(BuildContext context, WidgetRef ref, IrmaPartner partner) {
    return Column(
      children: [
        // CODE BOX
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: IrmaTheme.pureWhite,
            borderRadius: BorderRadius.circular(IrmaTheme.radiusCard),
            border: Border.all(color: IrmaTheme.borderLight),
            boxShadow: [
              BoxShadow(
                color: IrmaTheme.pureBlack.withOpacity(0.03),
                blurRadius: 20,
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                "Invite ${partner.name}",
                style: IrmaTheme.outfit.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Share this code with your partner",
                style: IrmaTheme.inter.copyWith(color: IrmaTheme.textSub),
              ),
              const SizedBox(height: 32),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: partner.inviteCode ?? ""));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Code copied to clipboard")),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                  decoration: BoxDecoration(
                    color: IrmaTheme.borderLight.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    partner.inviteCode ?? "000000",
                    style: IrmaTheme.outfit.copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 8,
                      color: IrmaTheme.textMain,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        
        // STATUS BOX (Gospel Style)
        IrmaStatusBox(
          label: "Waiting for ${partner.name} to connect...",
          color: IrmaTheme.ovulation,
          status: "Pending",
        ),
        
        const SizedBox(height: 40),
        TextButton(
          onPressed: () => ref.read(irmaPartnerProvider.notifier).disconnect(),
          child: const Text("Cancel Invitation", style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }

  Widget _buildConnectedState(BuildContext context, WidgetRef ref, IrmaPartner partner) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: IrmaTheme.pureWhite,
            borderRadius: BorderRadius.circular(IrmaTheme.radiusCard),
            border: Border.all(color: IrmaTheme.borderLight),
          ),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: IrmaTheme.luteal.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Iconsax.user, color: IrmaTheme.luteal, size: 32),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      partner.name,
                      style: IrmaTheme.outfit.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Connected since ${partner.createdAt.day}/${partner.createdAt.month}",
                      style: IrmaTheme.inter.copyWith(color: IrmaTheme.textSub),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        
        IrmaStatusBox(
          label: "Your cycle data is being shared",
          color: IrmaTheme.luteal,
          status: "Connected",
        ),

        const SizedBox(height: 60),
        TextButton(
          onPressed: () => ref.read(irmaPartnerProvider.notifier).disconnect(),
          child: const Text("Disconnect Partner", style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }


  void _showAddPartnerDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Invite Partner"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Enter partner's name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                ref.read(irmaPartnerProvider.notifier).createInvite(controller.text);
                Navigator.pop(context);
              }
            },
            child: const Text("Generate Code"),
          ),
        ],
      ),
    );
  }
}
