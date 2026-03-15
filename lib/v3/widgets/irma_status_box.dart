import 'package:flutter/material.dart';
import '../theme/irma_theme.dart';

class IrmaStatusBox extends StatelessWidget {
  final String label;
  final Color color;
  final String status;

  const IrmaStatusBox({
    super.key,
    required this.label,
    required this.color,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 345,
      height: 74,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(IrmaTheme.radiusCardSmall), // 16px Gospel Radius for Status Box
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: IrmaTheme.pureBlack.withOpacity(0.04),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 12),
              Text(
                status.toUpperCase(),
                style: IrmaTheme.outfit.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          Text(
            label,
            style: IrmaTheme.inter.copyWith(
              fontSize: 13,
              color: IrmaTheme.textSub,
            ),
          ),
        ],
      ),
    );
  }
}
