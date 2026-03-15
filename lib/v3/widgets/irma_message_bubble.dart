import 'package:flutter/material.dart';
import '../theme/irma_theme.dart';
import '../services/irma_ai_service.dart';

class IrmaMessageBubble extends StatelessWidget {
  final IrmaChatMessage message;

  const IrmaMessageBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isBot = message.role == MessageRole.model;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isBot) ...[
            _buildBotIcon(),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              constraints: BoxConstraints(
                maxWidth: isBot ? 293 : 113, // Strict Gospel dimensions
              ),
              decoration: BoxDecoration(
                color: isBot ? IrmaTheme.borderLight.withOpacity(0.3) : null,
                gradient: isBot ? null : IrmaTheme.primaryGradient,
                borderRadius: BorderRadius.circular(IrmaTheme.radiusCardSmall), // Strict 16px Radius
              ),
              child: Text(
                message.text,
                style: IrmaTheme.inter.copyWith(
                  color: isBot ? IrmaTheme.textMain : IrmaTheme.pureWhite,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBotIcon() {
    return Container(
      width: 22,
      height: 22,
      decoration: const BoxDecoration(
        color: IrmaTheme.ovulation,
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Icon(
          Icons.auto_awesome, // Using a standard icon as placeholder for the branding
          size: 14,
          color: IrmaTheme.pureWhite,
        ),
      ),
    );
  }
}
