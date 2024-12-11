import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> _cartItems = []; // To store cart items
  final DatabaseReference _productsRef = FirebaseDatabase.instance.ref().child('products'); // Firebase Realtime Database reference for products

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
  }

  // Fetch Cart Items from Firestore and product details from Realtime Database
  Future<void> _fetchCartItems() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;

      try {
        // Fetch user's cart data from Firestore
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('cart')
            .doc('initialCart')
            .get();

        if (snapshot.exists) {
          final items = snapshot.data()?['items'] as List<dynamic>?;
          if (items != null && items.isNotEmpty) {
            // Get the product IDs from the cart items
            List<String> productIds = items.map((item) => item['id'] as String).toList();

            // Fetch product details from Realtime Database for each product ID
            List<Map<String, dynamic>> productDetails = [];
            for (String productId in productIds) {
              final productSnapshot = await _productsRef.child(productId).get();
              if (productSnapshot.exists) {
                productDetails.add(Map<String, dynamic>.from(productSnapshot.value as Map));
              }
            }

            setState(() {
              // Map the cart items with product details
              _cartItems = items.map((item) {
                String productId = item['id'];
                Map<String, dynamic>? product = productDetails.firstWhere((prod) => prod['id'] == productId, orElse: () => {});
                return {
                  'product': product,
                  'quantity': item['quantity'],
                  'totalPrice': item['totalPrice'],
                };
              }).toList();
            });
          } else {
            print("No items found in cart.");
          }
        } else {
          print("No cart found for the user.");
        }
      } catch (e) {
        print("Error fetching cart items: $e");
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
          onPressed: () {},
        ),
        title: const Text(
          'Cart',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _cartItems.length,
              itemBuilder: (context, index) {
                final cartItem = _cartItems[index];
                final product = cartItem['product'];
                return _buildCartItem(
                  image: product?['imageUrl'] ?? 'default_image_url', // Assuming you have imageUrl in product data
                  name: product?['name'] ?? 'Unknown Product',
                  size: 'N/A',  // You might need to adjust the size field in your DB
                  price: product['price'].toString(),
                  quantity: cartItem['quantity'],
                );
              },
            ),
          ),
          const Divider(color: Color(0xFF2C2C2E), height: 1),
          _buildSummary(),
          const SizedBox(height: 16),
          _buildCheckoutButton(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildCartItem({
    required String image,
    required String name,
    required String size,
    required String price,
    required int quantity,
  }) {
    final imageUrl = image.isNotEmpty && image != 'default_image_url'
        ? image
        : 'https://i.ibb.co/JyL4Kx7/image.png'; // Replace with valid fallback image

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
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
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
                              'SIZE: $size',
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
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove, color: Colors.white),
                            onPressed: () {},
                            iconSize: 18,
                          ),
                          Text('$quantity', style: TextStyle(color: Colors.white)),
                          IconButton(
                            icon: const Icon(Icons.add, color: Colors.white),
                            onPressed: () {},
                            iconSize: 18,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.delete, color: Colors.white),
              onPressed: () {},
              iconSize: 20,
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildSummary() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryRow('Subtotal', '\$458,452'),
          const SizedBox(height: 8),
          _buildSummaryRow('Estimated Shipping', '\$48.00'),
          const SizedBox(height: 8),
          const Divider(color: Color(0xFF2C2C2E)),
          const SizedBox(height: 8),
          _buildSummaryRow(
            'Estimated Total',
            '\$458,500',
            isBold: true,
            fontSize: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value,
      {bool isBold = false, double fontSize = 14}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: Colors.white,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFA9C5D9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          minimumSize: const Size(double.infinity, 48),
        ),
        onPressed: () {},
        child: const Text(
          'CHECKOUT',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
