// lib/screens/journal_screen.dart
import 'package:flutter/material.dart';
import 'package:ui_challenger/screens/profile_screen.dart';
import '../components/bootm_nav_bar.dart';
import '../components/walker_hero.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  int _selectedIndex = 1; // middle tab selected

  void _onNavTapped(int index) {
    if (index == _selectedIndex) return;

    if (index == 0) {
      // back to DailyGoal
      Navigator.of(context).pop();
    } else if (index == 2) {
      // go to Profile
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ProfileScreen()),
      );
    } else {
      setState(() => _selectedIndex = index);
    }
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
                  // HEADER: JOURNAL + date + menu
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'JOURNAL',
                              style: TextStyle(
                                fontSize: 12,
                                letterSpacing: 1.5,
                                color: Color(0xFFB0B0B0),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                // small left arrow for previous day
                                Icon(Icons.chevron_left,
                                    size: 20,
                                    color: Colors.grey.withOpacity(0.6)),
                                const SizedBox(width: 4),
                                const Text(
                                  '13',
                                  style: TextStyle(
                                    fontSize: 64,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF273043),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'July 2020',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF9E9E9E),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.menu, color: Color(0xFF707070), size: 24),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // WALKER + BACKGROUND MOUNTAINS
                  Expanded(
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        // faint mountains in the background
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            height: 180,
                            width: double.infinity,
                            child: CustomPaint(
                              painter: _MountainsPainter(),
                            ),
                          ),
                        ),

                        // WALKING MAN (side view)
                        Align(
                          alignment: const Alignment(0.0, 0.4),
                          child: Hero(
                            tag: 'walkerHero',
                            flightShuttleBuilder: WalkerHero.flightShuttleBuilder,
                            child: const WalkerHero(
                              pose: WalkerPose.side, // 👈 use pose
                              size: 230,              // 👈 use size
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // JOURNAL CARD
                  _buildWalkCard(),

                  const SizedBox(height: 8),

                  // BOTTOM NAV (inside card)
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
      ),
    );
  }

  Widget _buildWalkCard() {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          // little map / thumbnail
          Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF3B82F6),
                  Color(0xFF1D4ED8),
                ],
              ),
            ),
            child: const Icon(Icons.map, color: Colors.white),
          ),
          const SizedBox(width: 16),
          // text
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '10:42',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9E9E9E),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Morning Walk',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF273043),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  '2km in 30mins',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9E9E9E),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.directions_walk,
            color: Color(0xFFFF7A2F),
          ),
        ],
      ),
    );
  }
}

// simple painter for the triangular "mountains"
class _MountainsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFF4F0EB);

    // big triangle
    final big = Path()
      ..moveTo(size.width * 0.2, size.height)
      ..lineTo(size.width * 0.5, size.height * 0.35)
      ..lineTo(size.width * 0.8, size.height)
      ..close();

    // small triangle
    final small = Path()
      ..moveTo(size.width * 0.05, size.height)
      ..lineTo(size.width * 0.25, size.height * 0.5)
      ..lineTo(size.width * 0.45, size.height)
      ..close();

    canvas.drawPath(big, paint);
    canvas.drawPath(small, paint..color = const Color(0xFFF7F3ED));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
