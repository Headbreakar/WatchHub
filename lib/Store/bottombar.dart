import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({super.key, required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20), // Added bottom margin for floating effect
      decoration: BoxDecoration(
        color: const Color.fromRGBO(33, 33, 33, 0.82),  // Semi-transparent gray
        borderRadius: const BorderRadius.all(Radius.circular(50)), // Fully circular edges
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Subtle shadow for floating effect
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 0), // Adjusted padding
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.home, "HOME"),
          _buildNavItem(1, Icons.tune, "FILTER"),
          _buildNavItem(2, Icons.shopping_bag, "CART"),
          _buildNavItem(3, Icons.person, "PROFILE"),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (isSelected)
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(right: 6),
                  decoration: const BoxDecoration(
                    color: Color(0xFF7EA1C1), // Blue dot for the active tab
                    shape: BoxShape.circle,
                  ),
                ),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey,
                  fontSize: 11, // Slightly smaller text
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4), // Slightly reduced spacing
          Icon(
            icon,
            color: isSelected ? Colors.white : Colors.grey,
            size: 20, // Smaller icon size
          ),
        ],
      ),
    );
  }
}
