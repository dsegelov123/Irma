import 'package:flutter/material.dart';
import '../theme/irma_theme.dart';

class IrmaInsightCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color baseColor;

  const IrmaInsightCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.baseColor = IrmaTheme.menstrual,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 168,
      height: 196,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: IrmaTheme.pureWhite,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: IrmaTheme.borderLight, width: 1),
        boxShadow: [
          BoxShadow(
            color: IrmaTheme.pureBlack.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: baseColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: baseColor, size: 24),
          ),
          const Spacer(),
          Text(
            title,
            style: IrmaTheme.inter.copyWith(
              color: IrmaTheme.textSub,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: IrmaTheme.outfit.copyWith(
              color: IrmaTheme.textMain,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class IrmaDashboardCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget content;
  final VoidCallback? onTap;

  const IrmaDashboardCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.content,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: IrmaTheme.pureWhite,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: IrmaTheme.borderLight),
          boxShadow: [
            BoxShadow(
              color: IrmaTheme.pureBlack.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: IrmaTheme.outfit.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: IrmaTheme.textMain,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: IrmaTheme.inter.copyWith(
                          fontSize: 13,
                          color: IrmaTheme.textSub,
                        ),
                      ),
                    ],
                  ],
                ),
                if (onTap != null)
                  const Icon(Icons.arrow_forward_ios, size: 14, color: IrmaTheme.textSub),
              ],
            ),
            const SizedBox(height: 20),
            content,
          ],
        ),
      ),
    );
  }
}
