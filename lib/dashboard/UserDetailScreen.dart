import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:cloud_firestore/cloud_firestore.dart';


class UserDetailScreen extends StatelessWidget {
  final Map<String, dynamic> user;

  const UserDetailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // Convert Firestore Timestamp to readable DateTime
    String formatDate(dynamic timestamp) {
      if (timestamp == null) return "N/A";
      try {
        return DateFormat('dd MMMM yyyy, hh:mm a')
            .format((timestamp as Timestamp).toDate());
      } catch (_) {
        return timestamp.toString(); // Fallback for other formats
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "User Details",
          style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              user['profileImageUrl'] ?? 'https://i.pravatar.cc/300',
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Picture
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  user['profileImageUrl'] ?? 'https://i.pravatar.cc/300',
                ),
              ),
            ),
            const SizedBox(height: 20),

            // User Details
            _buildDetailRow("Name", user['name']),
            const Divider(),
            _buildDetailRow("Email", user['email']),
            const Divider(),
            _buildDetailRow("Phone", user['phone']),
            const Divider(),
            _buildDetailRow("Address", user['address']),
            const Divider(),
            _buildDetailRow("Verified", user['isVerified'] == true ? "Yes" : "No"),
            const Divider(),
            _buildDetailRow("Admin Status", user['isAdmin'] == true ? "Admin" : "User"),
            const Divider(),
            _buildDetailRow("Registration Date", formatDate(user['createdAt'])),
            const Divider(),

            const SizedBox(height: 20),

            // View More Details Placeholder
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  print("View More Details Pressed");
                },
                icon: const Icon(Icons.info),
                label: const Text("View More Details"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build detail rows
  Widget _buildDetailRow(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value?.toString() ?? 'N/A',
              textAlign: TextAlign.end,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}
