import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildProfileHeader(),
              const SizedBox(height: 20),
              buildSectionTitle('Account Information'),
              buildAccountInfoList(),
              const SizedBox(height: 20),
              buildSectionTitle('Settings'),
              buildSettingsList(),
              const SizedBox(height: 20),
              buildSectionTitle('Order History'),
              buildOrderHistory(),
              const SizedBox(height: 40),
              buildLogoutButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProfileHeader() {
    return const Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage("profile_image.png"), // Replace with your image
          ),
          SizedBox(height: 16),
          Text(
            "John Doe", // User's name
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "johndoe@example.com", // User's email
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget buildAccountInfoList() {
    return Column(
      children: [
        buildListItem(Icons.person, "Edit Profile", onTap: () {
          // Handle Edit Profile Tap
        }),
        buildListItem(Icons.location_on, "Address", onTap: () {
          // Handle Address Tap
        }),
        buildListItem(Icons.credit_card, "Payment Methods", onTap: () {
          // Handle Payment Methods Tap
        }),
      ],
    );
  }

  Widget buildSettingsList() {
    return Column(
      children: [
        buildListItem(Icons.notifications, "Notifications", onTap: () {
          // Handle Notifications Tap
        }),
        buildListItem(Icons.security, "Privacy & Security", onTap: () {
          // Handle Privacy & Security Tap
        }),
        buildListItem(Icons.help, "Help Center", onTap: () {
          // Handle Help Center Tap
        }),
      ],
    );
  }

  Widget buildOrderHistory() {
    return Column(
      children: [
        buildListItem(Icons.shopping_bag, "View All Orders", onTap: () {
          // Handle Order History Tap
        }),
        buildListItem(Icons.access_time, "Track Orders", onTap: () {
          // Handle Track Orders Tap
        }),
      ],
    );
  }

  Widget buildLogoutButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
        ),
        onPressed: () {
          // Handle logout logic
          Navigator.pop(context);
        },
        child: const Text(
          "LOGOUT",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildListItem(IconData icon, String title, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }
}
