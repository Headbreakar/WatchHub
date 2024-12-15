import 'package:flutter/material.dart';

class OrderDetailScreen extends StatelessWidget {
  final Map<String, dynamic> order; // Order details passed from the previous screen

  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Order Details",
          style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Customer Name
            _buildDetailRow("Customer Name", order['customerName']),
            const SizedBox(height: 16),

            // Total Price
            _buildDetailRow("Total Price", "\$${order['totalPrice']}"),
            const SizedBox(height: 16),

            // Address
            _buildDetailRow("Address", order['address']),
            const SizedBox(height: 16),

            // Contact Number
            _buildDetailRow("Contact Number", order['contactNumber']),
            const SizedBox(height: 16),

            // Email
            _buildDetailRow("Email", order['email']),
            const SizedBox(height: 16),

            // Additional Notes
            _buildDetailRow("Notes", order['notes'] ?? "No additional notes"),
            const SizedBox(height: 16),

            // Order Date
            _buildDetailRow("Order Date", order['orderDate']),
            const SizedBox(height: 16),

            // Status
            _buildDetailRow("Status", order['status']),
          ],
        ),
      ),
    );
  }

  // Widget for displaying a detail row with a title and content
  Widget _buildDetailRow(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        Divider(height: 24, color: Colors.grey[400]),
      ],
    );
  }
}
