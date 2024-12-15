import 'package:flutter/material.dart';

class UserDetailScreen extends StatelessWidget {
  // Sample user details for demonstration purposes
  final Map<String, String> user;

  const UserDetailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
        title: const Text(
          "User Details",
          style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: const [
          CircleAvatar(
            backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Picture
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('https://i.pravatar.cc/300'), // Placeholder image
              ),
            ),
            const SizedBox(height: 20),
            // User Information
            Text(
              "Name: ${user['name'] ?? 'N/A'}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Text(
              "Email: ${user['email'] ?? 'N/A'}",
              style: const TextStyle(fontSize: 16),
            ),
            const Divider(),
            Text(
              "Phone: ${user['phone'] ?? 'N/A'}",
              style: const TextStyle(fontSize: 16),
            ),
            const Divider(),
            Text(
              "Address: ${user['address'] ?? 'N/A'}",
              style: const TextStyle(fontSize: 16),
            ),
            const Divider(),
            Text(
              "Date of Birth: ${user['dob'] ?? 'N/A'}",
              style: const TextStyle(fontSize: 16),
            ),
            const Divider(),
            Text(
              "Registration Date: ${user['registrationDate'] ?? 'N/A'}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            // View More Details Button

          ],
        ),
      ),
    );
  }
}
