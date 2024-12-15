import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutterofflie/Store/mainscreen.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({Key? key}) : super(key: key);

  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  List<Map<String, dynamic>> _wishlistItems = []; // To store wishlist items
  final DatabaseReference _productsRef =
  FirebaseDatabase.instance.ref().child(
      'products'); // Firebase Realtime Database reference
  bool _isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    _fetchWishlistItems();
  }

  Future<void> _addAllToCart() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;

      try {
        // Reference to the user's cart
        final cartRef = FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('cart')
            .doc('initialCart');

        // Fetch the current cart items
        final cartSnapshot = await cartRef.get();
        List<dynamic> cartItems = cartSnapshot.data()?['items'] ?? [];

        // Add each wishlist item to the cart
        for (var wishlistItem in _wishlistItems) {
          final product = wishlistItem['product'];

          // Check if the item is already in the cart
          final existingItemIndex = cartItems.indexWhere((item) =>
          item['id'] == product['id']);
          if (existingItemIndex >= 0) {
            // Update the quantity if the item exists
            cartItems[existingItemIndex]['quantity'] += 1;
          } else {
            // Add the new item to the cart
            cartItems.add({
              'id': product['id'],
              'name': product['name'],
              'price': product['price'],
              'quantity': 1, // Default quantity
            });
          }
        }

        // Update the cart in Firestore
        final double totalPrice = cartItems.fold(
          0.0,
              (sum, item) => sum + (item['price'] * item['quantity']),
        );

        await cartRef.set({
          'items': cartItems,
          'totalPrice': totalPrice,
        });

        // Optionally, clear the wishlist after adding to cart
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('wishlist')
            .doc('initialWishlist')
            .update({'items': []});

        setState(() {
          _wishlistItems = []; // Clear the local wishlist
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All items added to cart!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        print('Error adding all items to cart: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to add items to cart.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }


  // Fetch Wishlist Items from Firestore and product details from Realtime Database
  Future<void> _fetchWishlistItems() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;

      try {
        // Fetch user's wishlist data from Firestore
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('wishlist')
            .doc('initialWishlist')
            .get();

        if (snapshot.exists) {
          final items = snapshot.data()?['items'] as List<dynamic>?;

          if (items != null && items.isNotEmpty) {
            List<Map<String, dynamic>> updatedWishlistItems = [];

            for (var item in items) {
              // Fetch additional product details from Realtime Database
              final productSnapshot = await _productsRef.child(item['id'])
                  .get();

              if (productSnapshot.exists) {
                final productData = productSnapshot.value as Map<
                    dynamic,
                    dynamic>;
                updatedWishlistItems.add({
                  'product': {
                    'id': item['id'],
                    'name': productData['name'] ?? item['name'],
                    'price': num.tryParse(productData['price'].toString()) ?? 0,
                    'imageUrl': productData['imageUrl'] ??
                        'https://i.ibb.co/JyL4Kx7/image.png',
                    'description': productData['longDescription'] ??
                        'No description available',
                  },
                });
              } else {
                // Fallback to wishlist data if product details are missing
                updatedWishlistItems.add({
                  'product': {
                    'id': item['id'],
                    'name': item['name'],
                    'price': num.tryParse(item['price'].toString()) ?? 0,
                    'imageUrl': 'https://i.ibb.co/JyL4Kx7/image.png',
                    'description': 'No description available',
                  },
                });
              }
            }

            setState(() {
              _wishlistItems = updatedWishlistItems;
              _isLoading = false;
            });
          } else {
            setState(() {
              _wishlistItems = [];
              _isLoading = false;
            });
          }
        } else {
          setState(() {
            _wishlistItems = [];
            _isLoading = false;
          });
        }
      } catch (e) {
        print("Error fetching wishlist items: $e");
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _addToCart(String itemId, String name, String price) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;

      try {
        // Reference to the user's cart
        final cartRef = FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('cart')
            .doc('initialCart');

        // Fetch the current cart items
        final cartSnapshot = await cartRef.get();
        List<dynamic> cartItems = cartSnapshot.data()?['items'] ?? [];

        // Check if the item is already in the cart
        final existingItemIndex = cartItems.indexWhere((item) =>
        item['id'] == itemId);
        if (existingItemIndex >= 0) {
          // Update the quantity if the item exists
          cartItems[existingItemIndex]['quantity'] += 1;
        } else {
          // Add the new item to the cart
          cartItems.add({
            'id': itemId,
            'name': name,
            'price': num.tryParse(price) ?? 0,
            'quantity': 1, // Default quantity
          });
        }

        // Update the cart in Firestore
        final double totalPrice = cartItems.fold(
          0.0,
              (sum, item) => sum + (item['price'] * item['quantity']),
        );

        await cartRef.set({
          'items': cartItems,
          'totalPrice': totalPrice,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$name added to cart!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        print('Error adding item to cart: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to add item to cart.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }


  Future<void> _removeFromWishlist(String itemId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;

      try {
        final wishlistRef = FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('wishlist')
            .doc('initialWishlist');

        final wishlistSnapshot = await wishlistRef.get();

        if (wishlistSnapshot.exists) {
          final List<dynamic> items = wishlistSnapshot.data()?['items'] ?? [];

          items.removeWhere((item) => item['id'] == itemId);

          await wishlistRef.update({'items': items});

          setState(() {
            _wishlistItems.removeWhere((item) =>
            item['product']['id'] == itemId);
          });
        }
      } catch (e) {
        print('Error removing item from wishlist: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainScreen()),
            );
          },
        ),
        title: const Text(
          'Wishlist',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(
              child: CircularProgressIndicator(color: Colors.white),
            )
                : _wishlistItems.isEmpty
                ? const Center(
              child: Text(
                "Your wishlist is empty!",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _wishlistItems.length,
              itemBuilder: (context, index) {
                final wishlistItem = _wishlistItems[index];
                final product = wishlistItem['product'];
                return _buildWishlistItem(
                  image: product['imageUrl'] ?? 'default_image_url',
                  name: product['name'] ?? 'Unknown Product',
                  description: product['description'],
                  price: product['price'].toString(),
                  id: product['id'],
                );
              },
            ),
          ),
          if (_wishlistItems.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFA9C5D9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: const Size(double.infinity, 48),
                ),
                onPressed: _addAllToCart,
                child: const Text(
                  'Add All to Cart',
                  style: TextStyle(fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }


  Widget _buildWishlistItem({
    required String image,
    required String name,
    String? description,
    required String price,
    required String id,
  }) {
    final imageUrl = image.isNotEmpty && image != 'default_image_url'
        ? image
        : 'https://i.ibb.co/JyL4Kx7/image.png';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 80,
                  height: 112,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Description: ${description ??
                            'No description available'}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF8E8E93),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$$price',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => _addToCart(id, name, price),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFA9C5D9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          minimumSize: const Size(120, 36),
                        ),
                        child: const Text(
                          'Add to Cart',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Fixed delete icon placement
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.delete, color: Colors.white),
              onPressed: () {
                _removeFromWishlist(id);
              },
            ),
          ),
        ],
      ),
    );
  }
}