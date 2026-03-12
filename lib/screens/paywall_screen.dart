import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../services/subscription_service.dart';

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  List<Package> _packages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOfferings();
  }

  Future<void> _fetchOfferings() async {
    final packages = await SubscriptionService.getOfferings();
    setState(() {
      _packages = packages;
      _isLoading = false;
    });
  }

  Future<void> _purchasePackage(Package package) async {
    setState(() => _isLoading = true);
    final isPremium = await SubscriptionService.purchasePackage(package);
    if (isPremium) {
      if (!mounted) return;
      Navigator.of(context).pop(true); // Return success
    } else {
      setState(() => _isLoading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Purchase cancelled or failed.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.star_rounded, color: Color(0xFF6C63FF), size: 64),
                    const SizedBox(height: 16),
                    const Text(
                      'Irma Premium',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Unlock the full power of your cycle.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),

                    _buildFeatureRow(Icons.auto_awesome, 'Deep AI Insights', 'Complex correlations between your mood, energy, and cycle.'),
                    const SizedBox(height: 16),
                    _buildFeatureRow(Icons.insights, 'Advanced Analytics', 'Multi-month charts for symptom frequency and energy tracking.'),
                    const SizedBox(height: 16),
                    _buildFeatureRow(Icons.self_improvement, 'Cycle Syncing', 'Get daily, phase-specific wellness and nutrition recommendations.'),
                    
                    const SizedBox(height: 48),

                    if (_packages.isEmpty)
                      const Text('No subscription packages available right now.')
                    else
                      ..._packages.map((package) => Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: _buildSubscriptionButton(package),
                      )),

                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                         // Restore logic
                      },
                      child: const Text('Restore Purchases'),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF6C63FF)),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 4),
              Text(subtitle, style: TextStyle(color: Colors.grey.shade700)),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildSubscriptionButton(Package package) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: () => _purchasePackage(package),
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF6C63FF),
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Column(
          children: [
            Text(package.storeProduct.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(package.storeProduct.priceString, style: const TextStyle(fontSize: 14, color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}
