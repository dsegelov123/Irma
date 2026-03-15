import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/irma_theme.dart';
import '../widgets/irma_nav_bar.dart';
import '../widgets/irma_message_bubble.dart';
import '../widgets/irma_chat_input.dart';
import '../widgets/irma_faq_chip.dart';
import '../widgets/irma_chat_rich_content.dart';
import '../services/irma_ai_service.dart';

class IrmaChatScreen extends ConsumerStatefulWidget {
  const IrmaChatScreen({super.key});

  @override
  ConsumerState<IrmaChatScreen> createState() => _IrmaChatScreenState();
}

class _IrmaChatScreenState extends ConsumerState<IrmaChatScreen> {
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isAuntieThinking = false;

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage({String? customText}) async {
    final text = customText ?? _msgController.text.trim();
    if (text.isEmpty) return;

    if (customText == null) _msgController.clear();
    
    ref.read(irmaChatHistoryProvider.notifier).addMessage(text, MessageRole.user);
    _scrollToBottom();

    setState(() => _isAuntieThinking = true);

    final aiService = ref.read(irmaAIServiceProvider);
    final history = ref.read(irmaChatHistoryProvider);
    
    String fullResponse = "";
    
    try {
      final stream = aiService.streamChatResponse(history);
      
      // Add empty placeholder for "Auntie"
      ref.read(irmaChatHistoryProvider.notifier).addMessage("", MessageRole.model);
      
      await for (final chunk in stream) {
        fullResponse += chunk;
        final currentState = ref.read(irmaChatHistoryProvider);
        if (currentState.isNotEmpty) {
          final newState = List<IrmaChatMessage>.from(currentState);
          newState[newState.length - 1] = IrmaChatMessage(text: fullResponse, role: MessageRole.model);
          ref.read(irmaChatHistoryProvider.notifier).state = newState;
        }
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Auntie's a bit tired: ${e.toString()}")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isAuntieThinking = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final history = ref.watch(irmaChatHistoryProvider);

    return Scaffold(
      backgroundColor: IrmaTheme.pureWhite,
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 80), // Standard Gospel Top Spacer
              
              // CHAT LIST
              Expanded(
                child: history.isEmpty 
                  ? _buildEmptyState()
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24, // Gospel horizontal padding
                        vertical: 16,   // Gospel vertical spacing between messages
                      ),
                      itemCount: history.length,
                      itemBuilder: (context, index) {
                        return IrmaChatRichContent(
                          message: history[index],
                          onSuggestionSelected: (s) => _sendMessage(customText: s),
                        );
                      },
                    ),
              ),

              // INPUT AREA
              Padding(
                padding: const EdgeInsets.only(bottom: 32), // Spacing from bottom nav
                child: IrmaChatInput(
                  controller: _msgController,
                  isThinking: _isAuntieThinking,
                  onSend: _sendMessage,
                ),
              ),
            ],
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: IrmaNavigationBar(
              title: "Auntie Irma",
              subtitle: "Menstrual cramps relief",
              isChat: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const SizedBox(height: 40),
          // STARTER PILLS (Suggestions)
          IrmaFAQChip(
            label: "How can I relieve cramps?",
            onTap: () => _sendMessage(customText: "How can I relieve cramps?"),
          ),
          IrmaFAQChip(
            label: "What's my phase today?",
            onTap: () => _sendMessage(customText: "What's my phase today?"),
          ),
          IrmaFAQChip(
            label: "Tips for better sleep",
            onTap: () => _sendMessage(customText: "Tips for better sleep"),
          ),
          const SizedBox(height: 40),
          Text(
            "Talk to Auntie Irma",
            style: IrmaTheme.outfit.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: IrmaTheme.textMain,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Personalized wisdom for your cycle and wellness.",
            textAlign: TextAlign.center,
            style: IrmaTheme.inter.copyWith(color: IrmaTheme.textSub),
          ),
        ],
      ),
    );
  }
}
