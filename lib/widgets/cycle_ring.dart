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
              width: 240, // Increased size for glow
              height: 240,
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
                      Text(
                        'Day',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${widget.currentDayOfCycle}',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: 64,
                          color: AppColors.textPrimary,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: phaseColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.currentPhase,
                          style: TextStyle(
                            fontSize: 14,
                            color: phaseColor.withOpacity(0.9),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
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
    final radius = min(size.width / 2, size.height / 2) - 30; // Margin for glow
    const strokeWidth = 14.0;

    // Background track
    final trackPaint = Paint()
      ..color = AppColors.border.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    // Pulsing Glow
    final glowPaint = Paint()
      ..color = phaseColor.withOpacity(0.3 * pulseValue)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + (10.0 * pulseValue)
      ..strokeCap = StrokeCap.round
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 12.0 * pulseValue + 4.0);

    const startAngle = -pi / 2;
    final sweepAngle = animatedProgress * 2 * pi;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      glowPaint,
    );

    // Progress arc
    final progressPaint = Paint()
      ..color = phaseColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CycleRingPainter oldDelegate) {
    return oldDelegate.animatedProgress != animatedProgress ||
        oldDelegate.pulseValue != pulseValue ||
        oldDelegate.phaseColor != phaseColor;
  }
}
