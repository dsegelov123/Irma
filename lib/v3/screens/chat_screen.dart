import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../theme/irma_theme.dart';
import '../widgets/irma_nav_bar.dart';
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

  Future<void> _sendMessage() async {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;

    _msgController.clear();
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
        // Update the last message in state
        final currentState = ref.read(irmaChatHistoryProvider);
        if (currentState.isNotEmpty) {
          final newState = List<IrmaChatMessage>.from(currentState);
          newState[newState.length - 1] = IrmaChatMessage(text: fullResponse, role: MessageRole.model);
          ref.read(irmaChatHistoryProvider.notifier).state = newState;
        }
        _scrollToBottom();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Auntie's a bit tired: ${e.toString()}")),
      );
    } finally {
      setState(() => _isAuntieThinking = false);
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
              const SizedBox(height: 140), // Spacer for top nav
              
              // CHAT LIST
              Expanded(
                child: history.isEmpty 
                  ? _buildEmptyState()
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                      itemCount: history.length,
                      itemBuilder: (context, index) {
                        return ChatBubble(message: history[index]);
                      },
                    ),
              ),

              // INPUT AREA
              _buildInputArea(),
            ],
          ),

          // TOP NAV
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: IrmaNavigationBar(
              title: "Auntie Irma",
              showBackButton: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: IrmaTheme.ovulation.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Iconsax.magic_star, color: IrmaTheme.ovulation, size: 48),
            ),
            const SizedBox(height: 24),
            Text(
              "Ask Auntie Anything",
              style: IrmaTheme.outfit.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Get personal insights about your cycle, symptoms, or mental wellness.",
              textAlign: TextAlign.center,
              style: IrmaTheme.inter.copyWith(color: IrmaTheme.textSub),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
      decoration: BoxDecoration(
        color: IrmaTheme.pureWhite,
        boxShadow: [
          BoxShadow(
            color: IrmaTheme.pureBlack.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: IrmaTheme.borderLight.withOpacity(0.3),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _msgController,
                decoration: InputDecoration(
                  hintText: "Talk to Auntie...",
                  hintStyle: IrmaTheme.inter.copyWith(color: IrmaTheme.textSub),
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _isAuntieThinking ? null : _sendMessage,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: IrmaTheme.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(Iconsax.send_1, color: IrmaTheme.pureWhite, size: 24),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final IrmaChatMessage message;
  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == MessageRole.user;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isUser ? IrmaTheme.menstrual : IrmaTheme.borderLight.withOpacity(0.3),
          gradient: isUser ? IrmaTheme.primaryGradient : null,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isUser ? 20 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 20),
          ),
        ),
        child: Text(
          message.text,
          style: IrmaTheme.inter.copyWith(
            color: isUser ? IrmaTheme.pureWhite : IrmaTheme.textMain,
            fontSize: 15,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}
