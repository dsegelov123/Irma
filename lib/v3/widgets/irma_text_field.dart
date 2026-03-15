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
          width: 345, // EXACT Gospel Width
          height: 52, // EXACT Gospel Height
          decoration: BoxDecoration(
            color: IrmaTheme.pureWhite,
            borderRadius: BorderRadius.circular(IrmaTheme.radiusAction), // 32px Gospel Radius
            border: Border.all(
              color: IrmaTheme.borderLight,
              width: 1.5,
            ),
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword,
            keyboardType: keyboardType,
            style: IrmaTheme.inter.copyWith(color: IrmaTheme.textMain),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: IrmaTheme.inter.copyWith(color: IrmaTheme.textSub),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14), // Gospel Padding
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
