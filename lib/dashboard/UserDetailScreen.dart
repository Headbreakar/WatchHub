import 'package:flutter/material.dart';

class UserDetailScreen extends StatelessWidget {
  // Sample user details for demonstration purposes
  final Map<String, String> user;

  UserDetailScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
        title: Text(
          "User Details",
          style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
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
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('https://i.pravatar.cc/300'), // Placeholder image
              ),
            ),
            SizedBox(height: 20),
            // User Information
            Text(
              "Name: ${user['name'] ?? 'N/A'}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(),
            Text(
              "Email: ${user['email'] ?? 'N/A'}",
              style: TextStyle(fontSize: 16),
            ),
            Divider(),
            Text(
              "Phone: ${user['phone'] ?? 'N/A'}",
              style: TextStyle(fontSize: 16),
            ),
            Divider(),
            Text(
              "Address: ${user['address'] ?? 'N/A'}",
              style: TextStyle(fontSize: 16),
            ),
            Divider(),
            Text(
              "Date of Birth: ${user['dob'] ?? 'N/A'}",
              style: TextStyle(fontSize: 16),
            ),
            Divider(),
            Text(
              "Registration Date: ${user['registrationDate'] ?? 'N/A'}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            // View More Details Button

          ],
        ),
      ),
    );
  }
}
