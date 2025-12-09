import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../components/header.dart';

class DailyGoalScreen extends StatefulWidget {
  const DailyGoalScreen({super.key});

  @override
  State<DailyGoalScreen> createState() => _DailyGoalScreenState();
}

class _DailyGoalScreenState extends State<DailyGoalScreen>
    with TickerProviderStateMixin {
  late AnimationController _percentageController;
  late AnimationController _ringsController;
  late AnimationController _fadeController;
  late Animation<double> _percentageAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Percentage counter animation
    _percentageController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _percentageAnimation = Tween<double>(begin: 0, end: 87).animate(
      CurvedAnimation(parent: _percentageController, curve: Curves.easeOutCubic),
    );

    // Rings rotation animation (continuous)
    _ringsController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    // Fade in animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    // Start animations
    Future.delayed(const Duration(milliseconds: 300), () {
      _percentageController.forward();
      _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _percentageController.dispose();
    _ringsController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1ED),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Header(text: 'DAILY GOAL'),
              const SizedBox(height: 8),

              // Animated percentage
              AnimatedBuilder(
                animation: _percentageAnimation,
                builder: (context, child) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_percentageAnimation.value.toInt()}',
                        style: const TextStyle(
                          fontSize: 88,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2D3142),
                          height: 1.0,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          '%',
                          style: TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D3142),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 20),

              // Main content
              Expanded(
                child: Row(
                  children: [
                    // Left side - Stats
                    Expanded(
                      flex: 2,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildAnimatedStat(
                              Icons.local_fire_department,
                              1840,
                              'calories',
                              const Color(0xFFFF6B35),
                              0,
                            ),
                            _buildAnimatedStat(
                              Icons.directions_walk,
                              3248,
                              'steps',
                              const Color(0xFF6A4C93),
                              200,
                            ),
                            _buildAnimatedStat(
                              Icons.nightlight_round,
                              6.5,
                              'hours',
                              const Color(0xFF4ECDC4),
                              400,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Center - Character with rings
                    Expanded(
                      flex: 3,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Animated rings at bottom
                          Positioned(
                            bottom: 20,
                            child: AnimatedBuilder(
                              animation: _ringsController,
                              builder: (context, child) {
                                return Transform.rotate(
                                  angle: _ringsController.value * 2 * math.pi,
                                  child: CustomPaint(
                                    size: const Size(220, 100),
                                    painter: AnimatedRingsPainter(
                                      animationValue: _ringsController.value,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          // Character
                          Positioned(
                            bottom: 80,
                            child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: Image.asset(
                                'assets/avatar/walking_avatar_transparent.png',
                                height: 280,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Info card at bottom
              FadeTransition(
                opacity: _fadeAnimation,
                child: _buildInfoCard(),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildAnimatedStat(
    IconData icon,
    num value,
    String label,
    Color color,
    int delayMs,
  ) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1500),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, animValue, child) {
        return Opacity(
          opacity: animValue,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - animValue)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 28, color: color),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value is int
                          ? '${(value * animValue).toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}' 
                          : (value * animValue).toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3142),
                      ),
                    ),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF6A4C93).withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.dinner_dining_outlined,
              color: Color(0xFF6A4C93),
              size: 26,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "A simple way to",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF2D3142),
                  ),
                ),
                const Text(
                  "stay healthy",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF2D3142),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Dr Melissa",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.location_on,
            color: Color(0xFFFF6B9D),
            size: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushNamed(context, '/journal');
          }
        },
        selectedItemColor: const Color(0xFFFF6B9D),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart_rounded, size: 28),
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time_rounded, size: 28),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded, size: 28),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Custom painter for animated rings
class AnimatedRingsPainter extends CustomPainter {
  final double animationValue;

  AnimatedRingsPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;

    // Outer ring - Blue/Purple
    paint.color = const Color(0xFF6A4C93);
    canvas.drawArc(
      Rect.fromCenter(center: center, width: 200, height: 90),
      -math.pi / 2 + (animationValue * 0.3),
      math.pi * 1.7,
      false,
      paint,
    );

    // Middle ring - Orange/Red
    paint.color = const Color(0xFFFF6B35);
    canvas.drawArc(
      Rect.fromCenter(center: center, width: 150, height: 68),
      math.pi / 4 - (animationValue * 0.2),
      math.pi * 1.3,
      false,
      paint,
    );

    // Inner ring - Cyan/Blue
    paint.color = const Color(0xFF4ECDC4);
    canvas.drawArc(
      Rect.fromCenter(center: center, width: 100, height: 45),
      math.pi / 2 + (animationValue * 0.4),
      math.pi * 0.9,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(AnimatedRingsPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}
