import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'FeedbackScreen.dart';
import 'LogoutScreen.dart';
import 'OrdersScreen.dart';
import 'ProductsScreen.dart';
import 'UsersListScreen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Dynamic calculation variables
  int _totalUsers = 0;
  int _totalOrders = 0;
  int _completedOrders = 0;
  int _pendingOrders = 0;
  double _totalRevenue = 0.0;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  // Function to fetch all necessary dashboard data
  Future<void> _fetchDashboardData() async {
    try {
      // Fetch all users
      QuerySnapshot usersSnapshot =
      await FirebaseFirestore.instance.collection('users').get();

      int totalUsers = usersSnapshot.docs.length;
      int totalOrders = 0;
      int completedOrders = 0;
      int pendingOrders = 0;
      double totalRevenue = 0.0;

      // Loop through users to calculate order-related data
      for (var userDoc in usersSnapshot.docs) {
        QuerySnapshot ordersSnapshot =
        await userDoc.reference.collection('orders').get();

        for (var orderDoc in ordersSnapshot.docs) {
          totalOrders++;
          var data = orderDoc.data() as Map<String, dynamic>;
          if (data['status'] == 'Completed') {
            completedOrders++;
          } else {
            pendingOrders++;
          }
          totalRevenue += (data['totalPrice'] ?? 0).toDouble();
        }
      }

      setState(() {
        _totalUsers = totalUsers;
        _totalOrders = totalOrders;
        _completedOrders = completedOrders;
        _pendingOrders = pendingOrders;
        _totalRevenue = totalRevenue;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching dashboard data: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: const Text(
          "WatchHub Dashboard",
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
      drawer: _buildDrawer(context),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cards Section
              const Text(
                "Dashboard Stats",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              _buildStatCard("Total Users", _totalUsers.toString(), Icons.person, Colors.blue),
              _buildStatCard("Total Orders", _totalOrders.toString(),
                  Icons.shopping_cart, Colors.orange),
              _buildStatCard(
                  "Completed Orders",
                  _completedOrders.toString(),
                  Icons.check_circle,
                  Colors.green),
              _buildStatCard("Pending Orders", _pendingOrders.toString(),
                  Icons.hourglass_empty, Colors.red),
              _buildStatCard("Total Revenue", "\$${_totalRevenue.toStringAsFixed(2)}",
                  Icons.attach_money, Colors.purple),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to build stat cards
  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: Text(value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }

  // Drawer widget (unchanged)
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const UserAccountsDrawerHeader(
            accountName: Text("Anas Ashfaq"),
            accountEmail: Text("anas.ashfaq@example.com"),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage("https://i.pravatar.cc/300"),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text("Dashboard"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DashboardScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.production_quantity_limits),
            title: const Text("Products"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProductsScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text("Orders"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OrdersScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Users"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UsersListScreen()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.feedback),
            title: const Text("Feedbacks"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FeedbackScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LogoutScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
