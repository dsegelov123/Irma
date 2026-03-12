import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/daily_log.dart';
import '../models/cycle_data.dart';

class AIInsightService {
  // Mock endpoint for the Gemini API call
  static const String _geminiEndpoint = 'https://api.gemini.google.com/v1/generate';
  static const String _apiKey = 'YOUR_GEMINI_API_KEY';

  /// Generates a prompt ensuring no PII is included, only quantitative data
  static String _buildAnonymizedPrompt(
    List<DailyLog> recentLogs,
    CycleData currentCycle,
    String currentPhase,
    bool isPremium,
  ) {
    final buffer = StringBuffer();
    buffer.writeln("Analyze the following anonymized cycle data and provide a concise, empathetic daily insight.");
    
    if (isPremium) {
      buffer.writeln("You are providing a Premium insight. Look for complex correlations between symptoms, mood, and the cycle phase.");
    } else {
      buffer.writeln("You are providing a Basic insight. Focus only on general mood or energy trends for the current phase.");
    }

    buffer.writeln("\nCurrent Phase: $currentPhase");
    buffer.writeln("Cycle Day: ${DateTime.now().difference(currentCycle.startDate).inDays + 1}");
    
    buffer.writeln("\nRecent Activity:");
    // Only send the last 7 days of logs to save tokens and maintain privacy
    final logsToSend = recentLogs.take(7);
    for (var log in logsToSend) {
      buffer.writeln("- Day offset: ${DateTime.now().difference(log.date).inDays} days ago | Mood: ${log.mood} | Energy: ${log.energyLevel}/5 | Symptoms: ${log.symptoms.join(', ')}");
    }

    buffer.writeln("\nOutput only the insight specifically tailored for today. Keep it under 2 sentences.");
    return buffer.toString();
  }

  /// Calls the Gemini API to generate the insight
  static Future<String> generateDailyInsight({
    required List<DailyLog> recentLogs,
    required CycleData currentCycle,
    required String currentPhase,
    required bool isPremium,
  }) async {
    final prompt = _buildAnonymizedPrompt(recentLogs, currentCycle, currentPhase, isPremium);

    try {
      // NOTE: In a production environment, this call should ideally happen on a secure backend
      // to avoid shipping the API key in the app binary.
      final response = await http.post(
        Uri.parse('$_geminiEndpoint?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": prompt}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'] ?? "Unable to generate insight right now.";
      } else {
        return "You might feel a shift in energy today as your cycle progresses."; // Fallback
      }
    } catch (e) {
       return "Listen to your body today; rest if you need to."; // Error Fallback
    }
  }
}
