import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/irma_cycle_data.dart';
import '../models/irma_daily_log.dart';
import '../services/irma_cycle_engine.dart';
import '../services/irma_supabase_service.dart';
import '../services/irma_ai_service.dart';

// Provider to access the Hive box for Cycle Data
final irmaCycleBoxProvider = Provider<Box<IrmaCycleData>>((ref) {
  return Hive.box<IrmaCycleData>('irmaCycleBox');
});

// Provider that manages the Cycle Data state
final irmaCycleDataProvider = StateNotifierProvider<IrmaCycleDataNotifier, IrmaCycleData?>((ref) {
  final box = ref.watch(irmaCycleBoxProvider);
  final supabase = ref.watch(supabaseServiceProvider);
  return IrmaCycleDataNotifier(box, supabase);
});

class IrmaCycleDataNotifier extends StateNotifier<IrmaCycleData?> {
  final Box<IrmaCycleData> _box;
  final IrmaSupabaseService _supabase;

  IrmaCycleDataNotifier(this._box, this._supabase) : super(null) {
    _loadData();
  }

  void _loadData() {
    if (_box.isNotEmpty) {
      state = _box.getAt(0);
    }
  }

  Future<void> updateData(IrmaCycleData newData) async {
    await _box.clear();
    await _box.add(newData);
    state = newData;
    
    // Cloud Sync
    await _supabase.syncCycleData(newData);
  }
}

// Provider that calculates and returns the current Cycle State using the Engine
final irmaCycleStateProvider = Provider<IrmaCycleState?>((ref) {
  final cycleData = ref.watch(irmaCycleDataProvider);
  if (cycleData == null) return null;

  return IrmaCycleEngine.calculateState(cycleData, DateTime.now());
});

// --- DAILY LOGS ---

final irmaDailyLogProvider = StateNotifierProvider.family<IrmaDailyLogNotifier, IrmaDailyLog?, DateTime>((ref, date) {
  final box = Hive.box<IrmaDailyLog>('irmaDailyLogBox');
  final supabase = ref.watch(supabaseServiceProvider);
  return IrmaDailyLogNotifier(box, supabase, date);
});

class IrmaDailyLogNotifier extends StateNotifier<IrmaDailyLog?> {
  final Box<IrmaDailyLog> _box;
  final IrmaSupabaseService _supabase;
  final DateTime _date;

  IrmaDailyLogNotifier(this._box, this._supabase, this._date) : super(null) {
    _loadData();
  }

  void _loadData() {
    final key = _generateKey(_date);
    state = _box.get(key);
  }

  Future<void> updateLog({
    List<String>? symptoms,
    double? water,
    double? weight,
    String? note,
  }) async {
    final currentLog = state ?? IrmaDailyLog(date: _date);
    final updatedLog = IrmaDailyLog(
      date: _date,
      symptoms: symptoms ?? currentLog.symptoms,
      waterLiters: water ?? currentLog.waterLiters,
      weightKg: weight ?? currentLog.weightKg,
      note: note ?? currentLog.note,
    );

    await _box.put(_generateKey(_date), updatedLog);
    state = updatedLog;

    // Cloud Sync
    await _supabase.syncDailyLog(updatedLog);
  }

  String _generateKey(DateTime date) {
    return "${date.year}-${date.month}-${date.day}";
  }
}

// --- AI INSIGHTS ---

final irmaAIInsightProvider = FutureProvider<String>((ref) async {
  final cycleData = ref.watch(irmaCycleDataProvider);
  final aiService = ref.watch(irmaAIServiceProvider);
  
  if (cycleData == null) return "Tell us about your cycle to see personalized wisdom.";

  try {
    // For now, passing empty list of logs as we haven't built the 'History' fetcher yet
    // But this demonstrates the pattern.
    return await aiService.getQuickInsight(cycleData: cycleData, recentLogs: []);
  } catch (e) {
    return "I'm reflecting on your data, dear. Why don't you talk to me in the AI Helper tab?";
  }
});
