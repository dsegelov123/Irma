import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/irma_cycle_data.dart';
import '../models/irma_daily_log.dart';
import '../models/irma_partner.dart';

final supabaseServiceProvider = Provider((ref) => IrmaSupabaseService());

class IrmaSupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  // --- AUTHENTICATION ---
  
  User? get currentUser => _client.auth.currentUser;
  Session? get currentSession => _client.auth.currentSession;
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  Future<AuthResponse> signUp({required String email, required String password}) async {
    return await _client.auth.signUp(email: email, password: password);
  }

  Future<AuthResponse> signIn({required String email, required String password}) async {
    return await _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  // --- DATA SYNCING ---

  /// Syncs cycle data to the user's profile table
  Future<void> syncCycleData(IrmaCycleData data) async {
    if (currentUser == null) return;
    
    await _client.from('user_profiles').upsert({
      'id': currentUser!.id,
      'last_period_date': data.lastPeriodDate.toIso8601String(),
      'avg_cycle_length': data.avgCycleLength,
      'avg_period_length': data.avgPeriodLength,
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  /// Syncs a daily log to the logs table
  Future<void> syncDailyLog(IrmaDailyLog log) async {
    if (currentUser == null) return;

    await _client.from('daily_logs').upsert({
      'user_id': currentUser!.id,
      'date': log.date.toIso8601String().split('T')[0], // YYYY-MM-DD
      'symptoms': log.symptoms,
      'water_liters': log.waterLiters,
      'weight_kg': log.weightKg,
      'note': log.note,
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  /// Fetches all daily logs for the current user
  Future<List<Map<String, dynamic>>> fetchDailyLogs() async {
    if (currentUser == null) return [];
    
    return await _client
        .from('daily_logs')
        .select()
        .eq('user_id', currentUser!.id);
  }

  // --- PARTNER SYNC ---

  Future<void> syncPartner(IrmaPartner partner) async {
    if (currentUser == null) return;

    await _client.from('partners').upsert({
      'user_id': currentUser!.id,
      'partner_name': partner.name,
      'invite_code': partner.inviteCode,
      'status': partner.status.toString().split('.').last,
      'updated_at': DateTime.now().toIso8601String(),
    });
  }
}
