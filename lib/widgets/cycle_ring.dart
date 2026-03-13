import 'dart:math';
import 'package:flutter/material.dart';

class CycleRing extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final double progress = currentDayOfCycle / totalCycleLength;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 200,
          height: 200,
          child: TweenAnimationBuilder<double>(
            duration: const Duration(seconds: 1), // Adjusted duration for smoother animation
            curve: Curves.easeOutCubic,
            tween: Tween(begin: 0.0, end: progress),
            builder: (context, animatedProgress, child) {
              return CustomPaint(
                painter: _CycleRingPainter(
                  animatedProgress: animatedProgress,
                ),
                child: child, // Pass the child through
              );
            },
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Day $currentDayOfCycle',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6C63FF),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currentPhase,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CycleRingPainter extends CustomPainter {
  final int currentDayOfCycle;
  final int totalCycleLength;

  _CycleRingPainter({
    required this.currentDayOfCycle,
    required this.totalCycleLength,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);
    const strokeWidth = 16.0;

    // Background track
    final trackPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius - strokeWidth / 2, trackPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = const Color(0xFFB4A8D3) // Pastoral purple theme
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      // Adding a subtle shadow/glow
      ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 2.0);

    const startAngle = -pi / 2; // Start from top
    final sweepAngle = (currentDayOfCycle / totalCycleLength) * 2 * pi;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CycleRingPainter oldDelegate) {
    return oldDelegate.currentDayOfCycle != currentDayOfCycle ||
        oldDelegate.totalCycleLength != totalCycleLength;
  }
}
