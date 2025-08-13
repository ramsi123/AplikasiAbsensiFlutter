import 'package:aplikasi_absensi/components/my_bottom_nav_bar.dart';
import 'package:aplikasi_absensi/pages/absence_page.dart';
import 'package:aplikasi_absensi/pages/history_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => HomePage());
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // this selected index is to control the bottom nav bar
  int _selectedIndex = 0;

  // this method will update our selected index
  // when the user taps on the bottom bar
  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // pages to display
  final List<Widget> _pages = [
    // absence page
    AbsencePage(),

    // history page
    HistoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      bottomNavigationBar: MyBottomNavBar(
        onTabChange: (index) => navigateBottomBar(index),
      ),
      body: _pages[_selectedIndex],
    );
  }
}
