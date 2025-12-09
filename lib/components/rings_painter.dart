// lib/components/rings_painter.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';

class RingsPainter extends CustomPainter {
  final double progress;
  RingsPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    // Put the rings slightly under the avatar’s feet
    final center = Offset(
      size.width / 2,
      size.height / 2 + 22,
    );

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // 🔹 1) How much of the circle is visible
    // 0.85 = 85% of a full circle → small gap
    const double coverage = 0.85;
    final double outerSweep = 2 * math.pi * coverage * progress;

    // 🔹 2) Rotation: where the visible part starts
    // This angle decides where the *gap* ends up.
    // Try tweaking between 1.2 and 1.4 if needed.
    final double rotation = math.pi * 1.3;

    // ---- BACKGROUND / SHADOW RING (same gap position) ----
    paint
      ..color = Colors.black.withOpacity(0.05)
      ..strokeWidth = 10;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: 80),
      rotation,
      outerSweep,
      false,
      paint,
    );

    // ---- COLORED RINGS (all share same start → gap overlaps behind avatar) ----

    // OUTER BLUE
    paint
      ..strokeWidth = 9
      ..color = const Color(0xFF00A5FF);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: 80),
      rotation,
      outerSweep,
      false,
      paint,
    );

    // MIDDLE ORANGE (slightly shorter, slightly smaller radius)
    paint.color = const Color(0xFFFF7A2F);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: 68),
      rotation,
      outerSweep * 0.9,
      false,
      paint,
    );

    // INNER PINK (again a bit shorter)
    paint.color = const Color(0xFFFF4D8F);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: 56),
      rotation,
      outerSweep * 0.8,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant RingsPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
