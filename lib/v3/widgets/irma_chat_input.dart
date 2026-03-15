import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../theme/irma_theme.dart';

class IrmaChatInput extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isThinking;

  const IrmaChatInput({
    super.key,
    required this.controller,
    required this.onSend,
    this.isThinking = false,
  });

  @override
  State<IrmaChatInput> createState() => _IrmaChatInputState();
}

class _IrmaChatInputState extends State<IrmaChatInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 345, // Strict Gospel Width
      height: 112, // Strict Gospel Height
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: IrmaTheme.borderLight.withOpacity(0.2),
        borderRadius: BorderRadius.circular(IrmaTheme.radiusCard), // Strict 32px Radius
      ),
      child: Column(
        children: [
          Expanded(
            child: TextField(
              controller: widget.controller,
              maxLines: null,
              decoration: InputDecoration(
                hintText: "Type a message...",
                hintStyle: IrmaTheme.inter.copyWith(color: IrmaTheme.textSub),
                border: InputBorder.none,
              ),
              onSubmitted: (_) => widget.onSend(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: widget.isThinking ? null : widget.onSend,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: IrmaTheme.primaryGradient,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: widget.isThinking
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: IrmaTheme.pureWhite,
                            ),
                          )
                        : const Icon(Iconsax.send_1, color: IrmaTheme.pureWhite, size: 20),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
