import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/irma_partner.dart';
import 'irma_supabase_service.dart';

// Provider to manage the partner connection state
final irmaPartnerProvider = StateNotifierProvider<IrmaPartnerNotifier, IrmaPartner?>((ref) {
  final box = Hive.box<IrmaPartner>('irmaPartnerBox');
  final supabase = ref.watch(supabaseServiceProvider);
  return IrmaPartnerNotifier(box, supabase);
});

class IrmaPartnerNotifier extends StateNotifier<IrmaPartner?> {
  final Box<IrmaPartner> _box;
  final IrmaSupabaseService _supabase;

  IrmaPartnerNotifier(this._box, this._supabase) : super(null) {
    _loadData();
  }

  void _loadData() {
    if (_box.isNotEmpty) {
      state = _box.getAt(0);
    }
  }

  String generateInviteCode() {
    final random = Random();
    final code = List.generate(6, (index) => random.nextInt(10)).join();
    return code;
  }

  Future<void> createInvite(String partnerName) async {
    final code = generateInviteCode();
    final partner = IrmaPartner(
      name: partnerName,
      inviteCode: code,
      status: PartnerStatus.pending,
      createdAt: DateTime.now(),
    );
    await _box.clear();
    await _box.add(partner);
    state = partner;

    // Cloud Sync
    await _supabase.syncPartner(partner);
  }

  Future<bool> connectPartner(String code) async {
    // Simulating validation logic for now
    if (state != null && state!.inviteCode == code) {
      final updated = IrmaPartner(
        id: "partner-uuid-123", // Placeholder
        name: state!.name,
        inviteCode: state!.inviteCode,
        status: PartnerStatus.connected,
        createdAt: state!.createdAt,
      );
      await _box.putAt(0, updated);
      state = updated;

      // Cloud Sync
      await _supabase.syncPartner(updated);
      
      return true;
    }
    return false;
  }

  Future<void> disconnect() async {
    if (state != null) {
      final disconnected = IrmaPartner(
        name: state!.name,
        inviteCode: state!.inviteCode,
        status: PartnerStatus.disconnected,
        createdAt: state!.createdAt,
      );
      await _supabase.syncPartner(disconnected);
    }
    await _box.clear();
    state = null;
  }
}
