import 'package:flutter/material.dart';
import 'homepage.dart';
import 'category.dart';
import 'CartPage.dart';
import 'profile.dart';
import 'bottombar.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();

    // Initialize screens with a callback to trigger refresh
    _screens.addAll([
      HomePage(onCartUpdate: _refreshCart), // Pass callback
      CategoryPage(onCartUpdate: _refreshCart), // Pass callback
      CartPage(), // No callback needed for the CartPage itself
      ProfilePage(),
    ]);
  }

  void _refreshCart() {
    // Trigger a rebuild of the entire screen to refresh cart data
    setState(() {});
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Transparent background
      body: Stack(
        children: [
          // Screen content
          IndexedStack(
            index: _selectedIndex,
            children: _screens,
          ),
          // Conditionally display the floating bottom navigation bar
          if (_selectedIndex != 2) // Hide bar when on CartPage
            Positioned(
              bottom: 20, // Space between the bar and the bottom edge
              left: 20, // Space from the left
              right: 20, // Space from the right
              child: CustomBottomNavBar(
                selectedIndex: _selectedIndex,
                onItemTapped: _onItemTapped,
              ),
            ),
        ],
      ),
    );
  }
}
