import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/daily_log.dart';
import '../models/cycle_data.dart';

class AIInsightService {
  // Mock endpoint for the Gemini API call
  static const String _geminiEndpoint = 'https://api.gemini.google.com/v1/generate';
  static final String _apiKey = dotenv.env['GEMINI_API_KEY'] ?? 'YOUR_GEMINI_API_KEY';

  /// Generates a prompt ensuring no PII is included, only quantitative data
  static String _buildAnonymizedPrompt(
    List<DailyLog> recentLogs,
    CycleData currentCycle,
    String currentPhase,
    int cycleDay,
    bool isPremium,
  ) {
    final buffer = StringBuffer();
    buffer.writeln("Persona: You are 'Auntie Irma,' a Wise Mentor and Kindly Neighbor in her late 60s.");
    buffer.writeln("Tone: Grounded, calm, and empathetic. Use 'British Understatement' to handle sensitive topics with quiet dignity.");
    buffer.writeln("Rules: NEVER use pet names like 'love', 'dear', or 'pet'. Focus on proactive observations rather than clinical alerts.");
    
    buffer.writeln("\nAnalyze the following anonymized cycle data and provide a concise, supportive daily insight in your persona.");
    
    if (isPremium) {
      buffer.writeln("Premium mode: Provide deep wisdom by correlating multiple data points across the cycle.");
    } else {
      buffer.writeln("Basic mode: Provide a brief, supportive observation for today's phase.");
    }

    buffer.writeln("\nCurrent Phase: $currentPhase");
    buffer.writeln("Cycle Day: $cycleDay");
    
    buffer.writeln("\nRecent Activity Logs:");
    final logsToSend = recentLogs.take(7);
    for (var log in logsToSend) {
      buffer.writeln("- Offset: ${DateTime.now().difference(log.date).inDays} days ago | Mood: ${log.mood} | Energy: ${log.energyLevel}/5 | Symptoms: ${log.symptoms.join(', ')}");
    }

    buffer.writeln("\nTask: Output ONLY your insight for today. Keep it to 1-2 sentences. Avoid being overly familiar while remaining warm.");
    return buffer.toString();
  }

  /// Calls the Gemini API to generate the insight
  static Future<String> generateDailyInsight({
    required List<DailyLog> recentLogs,
    required CycleData currentCycle,
    required String currentPhase,
    required int cycleDay,
    required bool isPremium,
  }) async {
    final prompt = _buildAnonymizedPrompt(recentLogs, currentCycle, currentPhase, cycleDay, isPremium);

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
