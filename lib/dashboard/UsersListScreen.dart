import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'CategoriesScreen.dart';
import 'DashboardScreen.dart';
import 'FeedbackScreen.dart';
import 'LogoutScreen.dart';
import 'OrdersScreen.dart';
import 'ProductsScreen.dart';
import 'UserDetailScreen.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});

  @override
  _UsersListScreenState createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  List<Map<String, dynamic>> _users = []; // List to hold user data
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  // Function to fetch users from Firestore
  Future<void> _fetchUsers() async {
    try {
      final usersSnapshot = await FirebaseFirestore.instance.collection('users').get();

      setState(() {
        _users = usersSnapshot.docs.map((doc) {
          final data = doc.data();
          return {
            'id': doc.id,
            'name': data['name'] ?? 'No Name',
            'email': data['email'] ?? 'No Email',
            'profileImageUrl': data['profileImageUrl'] ??
                'https://i.pravatar.cc/300', // Default profile image
          };
        }).toList();
      });
    } catch (e) {
      print("Error fetching users: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch users: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: const Text(
          "Users",
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
      drawer: _buildDrawer(context), // Drawer widget (unchanged)
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loader while fetching users
          : _users.isEmpty
          ? const Center(child: Text("No users found."))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _users.length,
          itemBuilder: (context, index) {
            final user = _users[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Profile image and user info
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(user['profileImageUrl']),
                          backgroundColor: Colors.grey[300],
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user['name'],
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user['email'],
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // View and delete buttons
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.visibility, color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserDetailScreen(user: user),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _deleteUser(user['id'], user['name']);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Function to delete a user from Firestore
  Future<void> _deleteUser(String userId, String userName) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).delete();
      setState(() {
        _users.removeWhere((user) => user['id'] == userId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$userName has been deleted successfully!")),
      );
    } catch (e) {
      print("Error deleting user: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete $userName")),
      );
    }
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DashboardScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.production_quantity_limits),
            title: const Text("Products"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ProductsScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text("Categories"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CategoriesScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text("Orders"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const OrdersScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Users"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const UsersListScreen()));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.feedback),
            title: const Text("Feedbacks"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FeedbackScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LogoutScreen()));
            },
          ),
        ],
      ),
    );
  }
}
