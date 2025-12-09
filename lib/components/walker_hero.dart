// lib/components/walker_hero.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';

enum WalkerPose { front, side, profile }

class WalkerHero extends StatelessWidget {
  final WalkerPose pose;
  final double size;

  const WalkerHero({
    super.key,
    required this.pose,
    this.size = 260,
  });

  @override
  Widget build(BuildContext context) {
    switch (pose) {
      case WalkerPose.front:
        return Image.asset(
          'assets/gif/walk_front.gif',
          height: size,
          fit: BoxFit.contain,
          gaplessPlayback: true,
        );

      case WalkerPose.side:
        return Image.asset(
          'assets/gif/walk_side.gif',
          height: size,
          fit: BoxFit.contain,
          gaplessPlayback: true,
        );

      case WalkerPose.profile:
      // same avatar, but inside a soft circle (profile photo)
        return Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFF5F1FF), // pale circle behind avatar
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Image.asset(
              'assets/gif/walk_front.gif', // or a static PNG of the same guy
              fit: BoxFit.contain,
              gaplessPlayback: true,
            ),
          ),
        );
    }
  }

  // ---------- HERO ANIMATION LOGIC ----------

  static WalkerPose _poseOf(BuildContext context) {
    final hero = context.widget as Hero;
    final child = hero.child;
    if (child is WalkerHero) return child.pose;
    return WalkerPose.front;
  }

  static Widget flightShuttleBuilder(
      BuildContext flightContext,
      Animation<double> animation,
      HeroFlightDirection direction,
      BuildContext fromHeroContext,
      BuildContext toHeroContext,
      ) {
    final fromPose = _poseOf(fromHeroContext);
    final toPose = _poseOf(toHeroContext);

    final fromHero = (fromHeroContext.widget as Hero).child;
    final toHero = (toHeroContext.widget as Hero).child;

    final rotating =
        (fromPose == WalkerPose.front && toPose == WalkerPose.side) ||
            (fromPose == WalkerPose.side && toPose == WalkerPose.front);

    // ⬇️ 1) FRONT <-> SIDE : 3D rotation (for DailyGoal <-> Journal)
    if (rotating) {
      return AnimatedBuilder(
        animation: animation,
        builder: (context, _) {
          final t = animation.value;
          late Widget child;
          late double angle;

          if (t < 0.5) {
            child = fromHero;
            final localT = t / 0.5;
            angle = localT * (math.pi / 2); // 0..90°
          } else {
            child = toHero;
            final localT = (t - 0.5) / 0.5;
            angle = (1 - localT) * (math.pi / 2); // 90..0°
          }

          if (direction == HeroFlightDirection.pop) {
            angle = -angle;
          }

          final m = Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle);

          return Transform(
            alignment: Alignment.center,
            transform: m,
            child: child,
          );
        },
      );
    }

    // ⬇️ 2) Any transition involving PROFILE:
    // just scale + move smoothly (Hero handles the move for us).
    return ScaleTransition(
      scale: Tween<double>(begin: 0.9, end: 1.0).animate(
        CurvedAnimation(parent: animation, curve: Curves.easeOut),
      ),
      child: toHero,
    );
  }
}
