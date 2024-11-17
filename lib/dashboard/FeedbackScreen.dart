import 'package:flutter/material.dart';
import 'package:flutterofflie/dashboard/DashboardScreen.dart';
import 'package:flutterofflie/dashboard/OrdersScreen.dart';
import 'package:flutterofflie/dashboard/ProductsScreen.dart';

import 'LogoutScreen.dart';
import 'UsersListScreen.dart';

class FeedbackScreen extends StatelessWidget {
  // Example list of feedbacks
  final List<Map<String, String>> feedbackList = [
    {
      'userId': '123',
      'username': 'John Doe',
      'productName': 'Product A',
      'feedback': 'Great product, loved it!',
    },
    {
      'userId': '456',
      'username': 'Jane Smith',
      'productName': 'Product B',
      'feedback': 'Good quality, but the delivery was delayed.',
    },
    {
      'userId': '789',
      'username': 'Mark Wilson',
      'productName': 'Product C',
      'feedback': 'Not satisfied with the product.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Open the drawer
            },
          ),
        ),
        title: Text(
          "Feedback",
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
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
              leading: Icon(Icons.dashboard),
              title: Text("Dashboard"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.production_quantity_limits),
              title: Text("Products"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductsScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text("Orders"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrdersScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Users"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UsersListScreen()),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.feedback),
              title: Text("Feedbacks"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FeedbackScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LogoutScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: feedbackList.length,
        itemBuilder: (context, index) {
          final feedback = feedbackList[index];
          return Card(
            elevation: 2,
            margin: EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "User ID: ${feedback['userId']}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text("Username: ${feedback['username']}"),
                  SizedBox(height: 4),
                  Text("Product: ${feedback['productName']}"),
                  SizedBox(height: 8),
                  Text(
                    "Feedback:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(feedback['feedback'] ?? ""),
                  SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle delete action here
                        print("Delete feedback from ${feedback['username']}");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: Text("Delete",style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
