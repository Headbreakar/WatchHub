import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final List<Map<String, dynamic>> _allOrders = []; // List to store all orders
  final List<Map<String, dynamic>> _filteredOrders = []; // Filtered orders list
  bool _isLoading = true;
  String _selectedStatus = "All"; // Default filter value

  @override
  void initState() {
    super.initState();
    _fetchAllOrders();
  }

  // Fetch all orders from Firestore
  Future<void> _fetchAllOrders() async {
    try {
      final usersSnapshot = await FirebaseFirestore.instance.collection('users').get();

      for (var userDoc in usersSnapshot.docs) {
        final ordersSnapshot =
        await userDoc.reference.collection('orders').get();

        for (var orderDoc in ordersSnapshot.docs) {
          final data = orderDoc.data();
          final List<dynamic> itemsList = data['items'] ?? [];

          _allOrders.add({
            'orderId': orderDoc.id,
            'userId': userDoc.id,
            'userName': userDoc['name'] ?? 'Unknown User',
            'address': data['address'] ?? 'No Address',
            'createdAt': data['createdAt']?.toDate() ?? DateTime.now(),
            'items': itemsList,
            'totalPrice': data['totalPrice'] ?? 0,
            'status': data['status'] ?? 'Pending',
          });
        }
      }

      _applyFilter();
    } catch (e) {
      print("Error fetching orders: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch orders: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Function to filter orders based on status
  void _applyFilter() {
    setState(() {
      if (_selectedStatus == "All") {
        _filteredOrders
          ..clear()
          ..addAll(_allOrders);
      } else {
        _filteredOrders
          ..clear()
          ..addAll(_allOrders.where((order) => order['status'] == _selectedStatus));
      }
    });
  }

  // Function to update order status
  Future<void> _updateOrderStatus(String userId, String orderId, String newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('orders')
          .doc(orderId)
          .update({'status': newStatus});

      // Update local list and refresh UI
      setState(() {
        final index = _allOrders.indexWhere((order) => order['orderId'] == orderId);
        if (index != -1) {
          _allOrders[index]['status'] = newStatus;
        }
        _applyFilter();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Order status updated to $newStatus")),
      );
    } catch (e) {
      print("Error updating status: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update status: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Orders Management", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Dropdown filter
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Filter by Status:", style: TextStyle(fontSize: 18)),
                DropdownButton<String>(
                  value: _selectedStatus,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedStatus = newValue!;
                      _applyFilter();
                    });
                  },
                  items: ["All", "Pending", "Delivered", "Completed"]
                      .map((status) => DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  ))
                      .toList(),
                ),
              ],
            ),
          ),
          const Divider(),

          // Orders List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredOrders.isEmpty
                ? const Center(child: Text("No orders found."))
                : ListView.builder(
              itemCount: _filteredOrders.length,
              itemBuilder: (context, index) {
                final order = _filteredOrders[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text("Customer: ${order['userName']}"),
                    subtitle: Text(
                        "Address: ${order['address']}\nStatus: ${order['status']}"),
                    trailing: Text(_formatDate(order['createdAt'])),
                    onTap: () => _showOrderDetails(order),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Format Date
  String _formatDate(DateTime date) => "${date.day}/${date.month}/${date.year}";

  // Show Order Details with Editable Status
  void _showOrderDetails(Map<String, dynamic> order) {
    String _currentStatus = order['status'];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Order ID: ${order['orderId']}", style: const TextStyle(fontSize: 18)),
              Text("Customer: ${order['userName']}"),
              Text("Address: ${order['address']}"),
              Text("Total Price: \$${order['totalPrice']}"),
              const SizedBox(height: 16),
              const Text("Update Order Status:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButton<String>(
                value: _currentStatus,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _currentStatus = newValue;
                    });
                    _updateOrderStatus(order['userId'], order['orderId'], newValue);
                    Navigator.pop(context); // Close bottom sheet after update
                  }
                },
                items: ["Pending", "Delivered", "Completed"]
                    .map((status) => DropdownMenuItem(
                  value: status,
                  child: Text(status),
                ))
                    .toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
