import 'package:flutter/material.dart';
import 'irma_message_bubble.dart';
import 'irma_faq_chip.dart';
import '../services/irma_ai_service.dart';

/// A dynamic renderer that determines how to display AI content.
/// It can render standard text bubbles, list of suggestion chips, 
/// or complex cards based on the message type.
class IrmaChatRichContent extends StatelessWidget {
  final IrmaChatMessage message;
  final Function(String) onSuggestionSelected;

  const IrmaChatRichContent({
    super.key,
    required this.message,
    required this.onSuggestionSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Currently, we handle text messages. 
    // Logic for cards/multiple choice to be discussed and added here.
    
    if (message.text.startsWith("SUGGESTIONS:")) {
      return _buildSuggestions(message.text);
    }

    return IrmaMessageBubble(message: message);
  }

  Widget _buildSuggestions(String rawText) {
    final suggestions = rawText
        .replaceFirst("SUGGESTIONS:", "")
        .split("|")
        .where((s) => s.trim().isNotEmpty)
        .toList();

    return Column(
      children: suggestions.map((s) => IrmaFAQChip(
        label: s.trim(),
        onTap: () => onSuggestionSelected(s.trim()),
      )).toList(),
    );
  }
}
