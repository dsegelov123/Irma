import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/irma_cycle_data.dart';
import '../models/irma_daily_log.dart';

// --- MODELS ---

enum MessageRole { user, model }

class IrmaChatMessage {
  final String text;
  final MessageRole role;
  final DateTime timestamp;

  IrmaChatMessage({
    required this.text,
    required this.role,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

// --- SERVICE ---

final irmaAIServiceProvider = Provider((ref) => IrmaAIService());

class IrmaAIService {
  late final GenerativeModel _model;
  
  IrmaAIService() {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
      systemInstruction: Content.system(
        "You are Irma, a wise, empathetic, and slightly humorous health companion. "
        "Users call you 'Auntie'. You provide insights on menstrual cycles, mental wellness, and physical symptoms. "
        "Your tone is warm, supportive, and grounded in collective wisdom (Auntie's Wisdom). "
        "Always prioritize privacy and empathy. Keep responses concise and easy to read. "
        "IMPORTANT: You are an AI, not a doctor. Always include a subtle reminder to consult a professional for medical concerns when appropriate. "
        "Use biological terms (Follicular, Luteal, etc.) accurately when discussing the user's cycle."
      ),
    );
  }

  Future<String> getQuickInsight({
    required IrmaCycleData cycleData,
    required List<IrmaDailyLog> recentLogs,
  }) async {
    final prompt = "Based on my cycle data (Last start: ${cycleData.lastPeriodDate}), "
        "and my recent symptoms (${recentLogs.take(3).map((l) => l.symptoms).join(', ')}), "
        "what should I know about my current phase today?";
    
    final response = await _model.generateContent([Content.text(prompt)]);
    return response.text ?? "I'm reflecting on your data, dear. Let me get back to you.";
  }

  Stream<String> streamChatResponse(List<IrmaChatMessage> history) async* {
    final chat = _model.startChat(
      history: history.map((m) => Content(
        m.role == MessageRole.user ? 'user' : 'model',
        [TextPart(m.text)],
      )).toList(),
    );

    final lastMessage = history.last.text;
    final response = chat.sendMessageStream(Content.text(lastMessage));
    
    await for (final chunk in response) {
      if (chunk.text != null) {
        yield chunk.text!;
      }
    }
  }
}

// --- STATE MANAGEMENT ---

final irmaChatHistoryProvider = StateNotifierProvider<IrmaChatHistoryNotifier, List<IrmaChatMessage>>((ref) {
  return IrmaChatHistoryNotifier();
});

class IrmaChatHistoryNotifier extends StateNotifier<List<IrmaChatMessage>> {
  IrmaChatHistoryNotifier() : super([]);

  void addMessage(String text, MessageRole role) {
    state = [...state, IrmaChatMessage(text: text, role: role)];
  }

  void clear() {
    state = [];
  }
}
