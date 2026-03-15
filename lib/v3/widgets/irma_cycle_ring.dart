import 'package:flutter/material.dart';
import 'dart:math';
import '../theme/irma_theme.dart';
import '../models/irma_cycle_data.dart';

class IrmaCycleRing extends StatelessWidget {
  final int currentDay;
  final int totalDays;
  final IrmaCyclePhase phase;

  const IrmaCycleRing({
    super.key,
    required this.currentDay,
    required this.totalDays,
    required this.phase,
  });

  @override
  Widget build(BuildContext context) {
    final phaseColor = _getPhaseColor(phase);
    
    return Stack(
      alignment: Alignment.center,
      children: [
        // RING CONTAINER
        Container(
          width: 240,
          height: 240,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: IrmaTheme.pureWhite,
            boxShadow: [
              BoxShadow(
                color: phaseColor.withOpacity(0.1),
                blurRadius: 40,
                spreadRadius: 5,
              ),
            ],
          ),
          child: CustomPaint(
            painter: _CycleRingPainter(
              progress: currentDay / totalDays,
              color: phaseColor,
            ),
          ),
        ),

        // CENTER TEXT
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Day",
              style: IrmaTheme.inter.copyWith(
                color: IrmaTheme.textSub,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              currentDay.toString(),
              style: IrmaTheme.outfit.copyWith(
                color: IrmaTheme.textMain,
                fontSize: 64,
                fontWeight: FontWeight.bold,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 16), // EXACT Gospel Gap
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: phaseColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _getPhaseName(phase),
                style: IrmaTheme.inter.copyWith(
                  color: phaseColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getPhaseColor(IrmaCyclePhase phase) {
    switch (phase) {
      case IrmaCyclePhase.menstrual: return IrmaTheme.menstrual;
      case IrmaCyclePhase.follicular: return IrmaTheme.follicular;
      case IrmaCyclePhase.ovulation: return IrmaTheme.ovulation;
      case IrmaCyclePhase.luteal: return IrmaTheme.luteal;
    }
  }

  String _getPhaseName(IrmaCyclePhase phase) {
    switch (phase) {
      case IrmaCyclePhase.menstrual: return "MENSTRUAL";
      case IrmaCyclePhase.follicular: return "FOLLICULAR";
      case IrmaCyclePhase.ovulation: return "OVULATION";
      case IrmaCyclePhase.luteal: return "LUTEAL";
    }
  }
}

class _CycleRingPainter extends CustomPainter {
  final double progress;
  final Color color;

  _CycleRingPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 20) / 2;
    final strokeWidth = 16.0;

    // BACKGROUND TRACK
    final bgPaint = Paint()
      ..color = IrmaTheme.borderLight.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // PROGRESS ARC
    final progressPaint = Paint()
      ..shader = IrmaTheme.primaryGradient.createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final startAngle = -pi / 2;
    final sweepAngle = 2 * pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );

    // INDICATOR DOT AT PROGRESS HEAD
    final dotX = center.dx + radius * cos(startAngle + sweepAngle);
    final dotY = center.dy + radius * sin(startAngle + sweepAngle);
    
    final dotPaint = Paint()..color = IrmaTheme.pureWhite;
    final dotShadowPaint = Paint()..color = IrmaTheme.pureBlack.withOpacity(0.2)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawCircle(Offset(dotX, dotY), 8, dotShadowPaint);
    canvas.drawCircle(Offset(dotX, dotY), 6, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
