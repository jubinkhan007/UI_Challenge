// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';

import '../components/bootm_nav_bar.dart';
import '../components/walker_hero.dart';
import 'dailyGoal.dart';
import 'journal_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 2;

  void _onNavTapped(int index) {
    if (index == _selectedIndex) return;

    if (index == 0) {
      // go to Daily Goal screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const Dailygoal()),
      );
    } else if (index == 1) {
      // go to Journal screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const JournalScreen()),
      );
    } else {
      // index == 2 -> already here
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
                  // HEADER
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'PROFILE',
                              style: TextStyle(
                                fontSize: 12,
                                letterSpacing: 1.5,
                                color: Color(0xFFB0B0B0),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Ron',
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF273043),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '29 years old',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFFB0B0B0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.menu, color: Color(0xFF707070), size: 24),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // AVATAR IN CIRCLE (shared Hero)
                  Center(
                    child: Hero(
                      tag: 'walkerHero',
                      flightShuttleBuilder: WalkerHero.flightShuttleBuilder,
                      child: const WalkerHero(
                        pose: WalkerPose.profile,
                        size: 170,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Center(
                    child: Text(
                      'Daily goals',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFB0B0B0),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // GOAL CARDS
                  _goalTile(
                    color: const Color(0xFFFF7A2F),
                    icon: Icons.local_fire_department,
                    label: 'Calories',
                    value: '2,000',
                  ),
                  const SizedBox(height: 10),
                  _goalTile(
                    color: const Color(0xFF7B32FF),
                    icon: Icons.directions_walk,
                    label: 'Steps',
                    value: '3,500',
                  ),
                  const SizedBox(height: 10),
                  _goalTile(
                    color: const Color(0xFF009BFF),
                    icon: Icons.nightlight_round,
                    label: 'Sleep',
                    value: '8h',
                  ),

                  const Spacer(),

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

  Widget _goalTile({
    required Color color,
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 16),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
