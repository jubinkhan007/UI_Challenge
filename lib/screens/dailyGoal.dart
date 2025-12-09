// lib/screens/dailyGoal.dart
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ui_challenger/screens/profile_screen.dart';

import '../components/bootm_nav_bar.dart';
import '../components/header.dart';
import '../components/rings_painter.dart';
import '../components/walker_hero.dart';
import 'journal_screen.dart';

class Dailygoal extends StatefulWidget {
  const Dailygoal({super.key});


  @override
  State<Dailygoal> createState() => _DailygoalState();
}

class _DailygoalState extends State<Dailygoal> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;

  int _selectedIndex = 0;


  // 2. Add handler function
  void _onNavTapped(int index) {
    if (index == _selectedIndex) return;

    setState(() => _selectedIndex = index);

    if (index == 1) {
      // middle tab → Journal
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const JournalScreen()),
      );
    } else if (index == 2) {
      // right tab → Profile
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ProfileScreen()),
      );
    }
  }

  Route _buildJournalRoute() {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 700),
      pageBuilder: (_, __, ___) => const JournalScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final slide = Tween<Offset>(
          begin: const Offset(1, 0),  // from right
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOutCubic))
            .animate(animation);

        return SlideTransition(
          position: slide,
          child: child,
        );
      },
    );
  }

  @override
  void initState(){
    super.initState();
    _controller = AnimationController(vsync: this,
      duration: const Duration(seconds:2),);
    _controller.forward();

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF5E9DD),
        body: SafeArea(
            child: Container(
              color: const Color(0xFFF5E9DD),
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(36),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 30,
                      offset: const Offset(0, 20),
                    ),
                  ],
                ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1) HEADER ROW
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'DAILY GOAL',
                            style: TextStyle(
                              fontSize: 12,
                              letterSpacing: 1.5,
                              color: Color(0xFFB0B0B0),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '87',
                                style: TextStyle(
                                  fontSize: 72,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF273043),
                                ),
                              ),
                              SizedBox(width: 4),
                              Text(
                                '%',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Color(0xFFB0B0B0),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.menu, color: Color(0xFF707070), size: 24),
                  ],
                ),

                const SizedBox(height: 12),

                // 2) MAIN SPLIT SECTION (stats + avatar)
                Expanded(
                  child: Row(
                    children: [
                      // LEFT SIDE
                      Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildStat(Icons.local_fire_department, '1,840', 'calories', Colors.orange),
                            _buildStat(Icons.directions_walk, '3,248', 'steps', Colors.purple),
                            _buildStat(Icons.nights_stay, '6.5', 'hours', Colors.cyan),
                          ],
                        ),
                      ),

                      // RIGHT SIDE
                      Expanded(
                        flex: 3,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            // RINGS at the bottom
                            SizedBox(
                              width: 200,
                              height: 120, // a bit shorter so they hug the feet area
                              child: AnimatedBuilder(
                                animation: _animation,
                                builder: (context, child) {
                                  return CustomPaint(
                                    painter: RingsPainter(progress: _animation.value),
                                  );
                                },
                              ),
                            ),

                            // AVATAR slightly above the rings so feet touch the arc
                            // AVATAR slightly above the rings so feet touch the arc
                            Padding(
                              padding: const EdgeInsets.only(bottom: 40),
                              child: Hero(
                                tag: 'walkerHero',
                                flightShuttleBuilder: WalkerHero.flightShuttleBuilder,
                                child: const WalkerHero(
                                  pose: WalkerPose.front,   // FRONT pose here
                                  size: 260,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),

                // 3) INFO CARD
                _buildInfoCard(),

                const SizedBox(height: 8),

                // 4) BOTTOM NAV INSIDE CARD
                SizedBox(
                  height: 72,
                  child: CustomBottomNav(
                    selectedIndex: _selectedIndex,
                    onItemTapped: _onNavTapped,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
        )
    );
  }

  Widget _buildStat(IconData icon, String value, String label, Color color) {
    return Row( // 1. Main layout is Horizontal
      crossAxisAlignment: CrossAxisAlignment.start, // Align to top
      children: [
        // Left: The Icon
        Icon(icon, size: 28, color: color),

        const SizedBox(width: 12), // Spacing between icon and text

        // Right: The Stacked Text
        Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align text to left
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF273043),
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCard() {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        // The shadow makes it "float"
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          // Purple Icon Box
          Container(
            height: 50, width: 50,
            decoration: BoxDecoration(
                color: Colors.deepPurple[50],
                borderRadius: BorderRadius.circular(12)
            ),
            child: const Icon(Icons.bar_chart, color: Colors.deepPurple),
          ),
          const SizedBox(width: 16),

          // Text Info
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("A simple way to", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const Text("stay healthy", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 4),
              Text("Dr Melissa", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            ],
          ),

          const Spacer(),
          // Location Pin
          const Icon(Icons.location_on, color: Colors.pinkAccent),
        ],
      ),
    );
  }



}
