import 'package:flutter/material.dart';
import 'package:flutterofflie/dashboard/AddProductScreen.dart';
import 'package:flutterofflie/dashboard/EditProductScreen.dart';
import 'package:firebase_database/firebase_database.dart'; // Import Firebase
import 'dart:async';

import 'CategoriesScreen.dart';
import 'DashboardScreen.dart';
import 'FeedbackScreen.dart';
import 'LogoutScreen.dart';
import 'OrdersScreen.dart';
import 'UsersListScreen.dart'; // For Future handling

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final DatabaseReference _productsRef = FirebaseDatabase.instance.ref().child('products');

  // List of products fetched from Firebase
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _filteredProducts = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchProducts(); // Fetch products when screen is loaded
  }

  // Function to fetch products from Firebase
  Future<void> _fetchProducts() async {
    try {
      final DatabaseEvent event = await _productsRef.once();
      final data = event.snapshot.value as Map?;

      if (data != null) {
        final List<Map<String, dynamic>> fetchedProducts = data.entries.map((entry) {
          final productData = entry.value as Map;
          return {
            'productId': entry.key, // Add the productId here
            'name': productData['name'].toString(),
            'description': productData['shortDescription'].toString(),
            'image': productData['imageUrl'].toString(),
          };
        }).toList();

        setState(() {
          _products = fetchedProducts;
          _filteredProducts = fetchedProducts;
          _isLoading = false;
        });
      }
    } catch (error) {
      print("Error fetching products: $error");
      setState(() {
        _isLoading = false;
      });
    }
  }


  // Function to handle search query changes
  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _filteredProducts = _products.where((product) {
        final name = product['name']!.toLowerCase();
        final description = product['description']!.toLowerCase();
        final searchLower = query.toLowerCase();

        // Check if the query matches the product name or description
        return name.contains(searchLower) || description.contains(searchLower);
      }).toList();
    });
  }

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
          "Products",
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
              leading: Icon(Icons.category),
              title: Text("Categories"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CategoriesScreen()),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search, color: Colors.grey),
                  hintText: "Search for a product",
                  border: InputBorder.none,
                ),
                onChanged: _onSearchChanged, // Call onSearchChanged when text changes
              ),
            ),
            SizedBox(height: 20),

            // Add Product Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddProductScreen()),
                );
              },
              child: Text("Add Product", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 20),

            // Products List
            _isLoading
                ? Center(child: CircularProgressIndicator()) // Show loading spinner
                : Expanded(
              child: ListView.builder(
                itemCount: _filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = _filteredProducts[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(product['image']!),
                      ),
                      title: Text(
                        product['name']!,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(product['description']!),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Edit Button
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              // Pass the product's dynamic ID to the EditProductScreen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProductScreen(
                                    productId: product['productId']!, // Pass the correct productId
                                  ),
                                ),
                              );
                            },
                          ),
                          // Delete Button
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              // Implement delete functionality here
                              print("Delete button pressed for ${product['name']}");
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
