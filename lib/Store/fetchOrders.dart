import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Import the intl package

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({Key? key}) : super(key: key);

  @override
  _MyOrdersPageState createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  List<Map<String, dynamic>> _orders = []; // To store orders
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  // Fetch Orders from Firestore
  Future<void> _fetchOrders() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;

      try {
        // Fetch orders from Firestore
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('orders')
            .get();

        if (snapshot.docs.isNotEmpty) {
          List<Map<String, dynamic>> orders = [];
          for (var doc in snapshot.docs) {
            final orderData = doc.data();
            Map<String, dynamic> order = {
              'orderId': doc.id,  // Order ID is the document ID
              'status': orderData['status'],
              'createdAt': orderData['createdAt'],
              'totalPrice': orderData['totalPrice'],
              'items': orderData['items'],
            };
            orders.add(order);
          }

          setState(() {
            _orders = orders;
            _isLoading = false;
          });
        } else {
          setState(() {
            _orders = [];
            _isLoading = false;
          });
        }
      } catch (e) {
        print("Error fetching orders: $e");
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Format the Firestore Timestamp to a readable string
  String formatTimestamp(Timestamp timestamp) {
    return DateFormat('MM/dd/yyyy, hh:mm a').format(timestamp.toDate());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Navigate back to HomePage
          },
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'My Orders',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : _orders.isEmpty
          ? const Center(
        child: Text(
          "No orders found.",
          style: TextStyle(color: Colors.white),
        ),
      )
          : ListView.builder(
        itemCount: _orders.length,
        itemBuilder: (context, index) {
          final order = _orders[index];
          return _buildOrderItem(order);
        },
      ),
    );
  }

  Widget _buildOrderItem(Map<String, dynamic> order) {
    final orderId = order['orderId'];
    final status = order['status'];
    final createdAt = order['createdAt']; // Timestamp
    final totalPrice = order['totalPrice'];
    final items = List<Map<String, dynamic>>.from(order['items']);

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order ID: $orderId' ,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Status: $status',
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              'Created at: ${formatTimestamp(createdAt)}', // Use formatted timestamp
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    '${item['name']} - ${item['quantity']} x \$${item['price']}',
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
            ),
            const Divider(color: Color(0xFF2C2C2E)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Total Price: \$${totalPrice}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
