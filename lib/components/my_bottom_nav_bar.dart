import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MyBottomNavBar extends StatelessWidget {
  final Function(int)? onTabChange;
  const MyBottomNavBar({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
      padding: EdgeInsets.symmetric(vertical: 15),
      child: GNav(
        color: Colors.grey[400],
        activeColor: Colors.grey.shade700,
        tabActiveBorder: Border.all(color: Colors.white),
        tabBackgroundColor: Colors.grey.shade300,
        backgroundColor: Theme.of(context).colorScheme.surface,
        mainAxisAlignment: MainAxisAlignment.center,
        tabBorderRadius: 16,
        gap: 8,
        onTabChange: (value) => onTabChange!(value),
        tabs: [
          GButton(icon: Icons.home, text: "Attendance"),
          GButton(icon: Icons.history, text: "History"),
        ],
      ),
    );
  }
}
