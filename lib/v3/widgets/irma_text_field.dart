import 'package:flutter/material.dart';
import '../theme/irma_theme.dart';

class IrmaTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;

  const IrmaTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: IrmaTheme.outfit.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: IrmaTheme.textMain,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: IrmaTheme.pureWhite,
            borderRadius: BorderRadius.circular(IrmaTheme.radiusAction), // 24px Gospel Radius for Inputs
            border: Border.all(
              color: IrmaTheme.borderLight,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: IrmaTheme.pureBlack.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword,
            keyboardType: keyboardType,
            style: IrmaTheme.inter.copyWith(color: IrmaTheme.textMain),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: IrmaTheme.inter.copyWith(color: IrmaTheme.textSub),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
