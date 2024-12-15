import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutterofflie/Store/Product.dart';
import 'package:flutterofflie/Store/category.dart';
import 'package:flutterofflie/Store/profile.dart';
import 'package:flutterofflie/Store/wishlist.dart';


class HomePage extends StatefulWidget {
  final VoidCallback onCartUpdate; // Callback to notify parent of cart changes

  const HomePage({super.key, required this.onCartUpdate}); // Constructor to accept the callback

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseReference _productsRef =
  FirebaseDatabase.instance.ref().child('products');

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildAppBar(),
                const SizedBox(height: 20),
                buildSearchBar(),
                const SizedBox(height: 16),
                buildCategoryToggle(context),
                const SizedBox(height: 20),
                FutureBuilder(
                  future: _productsRef.get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          'Error fetching data',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    if (!snapshot.hasData ||
                        (snapshot.data as DataSnapshot).value == null) {
                      return const Center(
                        child: Text(
                          'No products found',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    Map products = (snapshot.data as DataSnapshot).value as Map;
                    List items = products.entries
                        .where((product) =>
                        product.value['name']
                            .toString()
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase()))
                        .toList();

                    return buildWatchGrid(items);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAppBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            "watchHub__1_-removebg-preview.png",
            width: 150,
            height: 40,
            fit: BoxFit.contain,
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.favorite_border, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WishlistPage(), // Navigate to WishlistPage
                    ),
                  );
                },
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilePage(), // Replace with your ProfileScreen widget
                    ),
                  );
                },
                child: FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser?.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      );
                    }
                    if (snapshot.hasError || !snapshot.hasData || snapshot.data?.data() == null) {
                      return const CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 20,
                        child: Icon(Icons.error, color: Colors.red),
                      );
                    }

                    final data = snapshot.data!.data() as Map<String, dynamic>;
                    final profileImageUrl = data['profileImageUrl'] ?? '';

                    return CircleAvatar(
                      backgroundImage: profileImageUrl.isNotEmpty
                          ? NetworkImage(profileImageUrl)
                          : const AssetImage("Profile_Image.png") as ImageProvider,
                      radius: 20,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }



  Widget buildSearchBar() {
    return TextField(
      controller: _searchController,
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
      decoration: InputDecoration(
        hintText: "Search Product",
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFF333333),
        contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget buildCategoryToggle(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              // Redirect to TrendingPage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryPage(
                    onCartUpdate: widget.onCartUpdate, // Pass the callback
                  ),
                ),
              );
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF7EA1C1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Center(
                child: Text(
                  "Trending",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: () {
              // Redirect to CategoryPage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryPage(
                    onCartUpdate: widget.onCartUpdate, // Pass the callback
                  ),
                ),
              );
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF212121),
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Center(
                child: Text(
                  "Category",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildWatchGrid(List items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        var product = items[index].value;
        var productId = items[index].key; // Assuming 'key' holds the productId
        return buildWatchCard(
          product['imageUrl'],
          product['name'],
          "${product['price']} USD",
          product['shortDescription'],
          productId, // Pass productId here
        );
      },
    );
  }

  Widget buildWatchCard(
      String imagePath,
      String name,
      String price,
      String shortDescription,
      String productId,
      ) {
    return GestureDetector(
      onTap: () {
        // Navigate to ProductPage with productId
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductPage(productId: productId),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.network(
                imagePath,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 180,
                    color: Colors.grey[800],
                    child: const Center(
                      child: Icon(Icons.error, color: Colors.red),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    price,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    shortDescription,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
