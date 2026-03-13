import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CycleRing extends StatefulWidget {
  final int currentDayOfCycle;
  final int totalCycleLength;
  final String currentPhase;

  const CycleRing({
    super.key,
    required this.currentDayOfCycle,
    required this.totalCycleLength,
    required this.currentPhase,
  });

  @override
  State<CycleRing> createState() => _CycleRingState();
}

class _CycleRingState extends State<CycleRing> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double progress = widget.currentDayOfCycle / widget.totalCycleLength;
    final phaseColor = AppColors.getPhaseColor(widget.currentPhase);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return SizedBox(
              width: 280, 
              height: 280,
              child: TweenAnimationBuilder<double>(
                duration: const Duration(seconds: 1),
                curve: Curves.easeOutCubic,
                tween: Tween(begin: 0.0, end: progress),
                builder: (context, animatedProgress, child) {
                  return CustomPaint(
                    painter: _CycleRingPainter(
                      animatedProgress: animatedProgress,
                      phaseColor: phaseColor,
                      pulseValue: _pulseAnimation.value,
                    ),
                    child: child,
                  );
                },
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.water_drop, color: AppColors.primary, size: 32),
                      const SizedBox(height: 8),
                      Text(
                        'Day ${widget.currentDayOfCycle}',
                        style: const TextStyle(
                          fontFamily: 'Lufga',
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          'Low chance of getting pregnant',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary.withOpacity(0.8),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _CycleRingPainter extends CustomPainter {
  final double animatedProgress;
  final Color phaseColor;
  final double pulseValue;

  _CycleRingPainter({
    required this.animatedProgress,
    required this.phaseColor,
    required this.pulseValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2) - 20;
    const strokeWidth = 12.0;

    // 1. Dotted Background Track
    final trackPaint = Paint()
      ..color = AppColors.border.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final double dashLength = (2 * pi * radius) / 60; // 60 dots
    for (double i = 0; i < 2 * pi; i += dashLength / radius * 2) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        i - pi / 2,
        0.02,
        false,
        trackPaint,
      );
    }

    // 2. Solid Phase Arc
    final phasePaint = Paint()
      ..color = phaseColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    const startAngle = -pi / 2;
    final sweepAngle = animatedProgress * 2 * pi;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      phasePaint,
    );

    // 3. Optional Glow for Pulse
    if (pulseValue > 0.1) {
      final glowPaint = Paint()
        ..color = phaseColor.withOpacity(0.15 * pulseValue)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + 8
        ..strokeCap = StrokeCap.round
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10.0 * pulseValue);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        glowPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CycleRingPainter oldDelegate) {
    return oldDelegate.animatedProgress != animatedProgress ||
        oldDelegate.pulseValue != pulseValue ||
        oldDelegate.phaseColor != phaseColor;
  }
}
