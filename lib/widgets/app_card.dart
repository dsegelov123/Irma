import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final double? borderRadius;
  final BoxBorder? border;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.borderRadius,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color ?? AppColors.card,
        borderRadius: BorderRadius.circular(borderRadius ?? 24.0),
        border: border ?? Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 20,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}
