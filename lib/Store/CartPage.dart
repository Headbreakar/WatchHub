import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutterofflie/Store/mainscreen.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> _cartItems = []; // To store cart items
  final DatabaseReference _productsRef =
  FirebaseDatabase.instance.ref().child('products'); // Firebase Realtime Database reference for products
  bool _isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context)?.isCurrent == true) {
      _fetchCartItems();
    }
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
            List<Map<String, dynamic>> updatedCartItems = [];

            for (var item in items) {
              // Fetch additional product details from Realtime Database
              final productSnapshot = await _productsRef.child(item['id']).get();

              if (productSnapshot.exists) {
                final productData = productSnapshot.value as Map<dynamic, dynamic>;
                updatedCartItems.add({
                  'product': {
                    'id': item['id'], // Ensure ID is included
                    'name': productData['name'] ?? item['name'],
                    'price': num.tryParse(productData['price'].toString()) ?? 0, // Parse price as num
                    'imageUrl': productData['imageUrl'] ?? 'https://i.ibb.co/JyL4Kx7/image.png',
                    'description': productData['longDescription'] ?? 'No description available',
                  },
                  'quantity': num.tryParse(item['quantity'].toString()) ?? 0, // Parse quantity as num
                  'totalPrice': (num.tryParse(productData['price'].toString()) ?? 0) *
                      (num.tryParse(item['quantity'].toString()) ?? 0), // Calculate totalPrice
                });
              } else {
                // Fallback to cart data if product details are missing
                updatedCartItems.add({
                  'product': {
                    'id': item['id'],
                    'name': item['name'],
                    'price': num.tryParse(item['price'].toString()) ?? 0, // Parse price as num
                    'imageUrl': 'https://i.ibb.co/JyL4Kx7/image.png',
                    'description': 'No description available',
                  },
                  'quantity': num.tryParse(item['quantity'].toString()) ?? 0, // Parse quantity as num
                  'totalPrice': (num.tryParse(item['price'].toString()) ?? 0) *
                      (num.tryParse(item['quantity'].toString()) ?? 0), // Calculate totalPrice
                });
              }
            }

            setState(() {
              _cartItems = updatedCartItems;
              _isLoading = false; // Stop loading
            });
          } else {
            setState(() {
              _cartItems = []; // No items
              _isLoading = false; // Stop loading
            });
          }
        } else {
          setState(() {
            _cartItems = []; // No cart found
            _isLoading = false; // Stop loading
          });
        }
      } catch (e) {
        print("Error fetching cart items: $e");
        setState(() {
          _isLoading = false; // Stop loading on error
        });
      }
    }
  }

  Future<void> _updateCartInFirebaseWithList(List<Map<String, dynamic>> updatedCartItems) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;

      try {
        final cartRef = FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('cart')
            .doc('initialCart');

        // Calculate the new totalPrice for the cart
        final double totalPrice = updatedCartItems.fold(
          0.0,
              (sum, item) => sum + ((item['product']['price'] ?? 0) * (item['quantity'] ?? 0)),
        );

        // Prepare the updated items for Firestore
        final firebaseItems = updatedCartItems.map((item) {
          return {
            'id': item['product']['id'],
            'name': item['product']['name'],
            'price': item['product']['price'],
            'quantity': item['quantity'],
          };
        }).toList();

        // Update the cart in Firestore with the new totalPrice
        await cartRef.update({
          'items': firebaseItems,
          'totalPrice': totalPrice, // Update the total price in Firestore
        });
      } catch (e) {
        print('Error updating cart: $e');
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
              MaterialPageRoute(builder: (context) => MainScreen()),
            );
          },
        ),
        title: const Text(
          'Cart',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(color: Colors.white),
      )
          : _cartItems.isEmpty
          ? Center(
        child: Text(
          "Your cart is empty!",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _cartItems.length,
              itemBuilder: (context, index) {
                final cartItem = _cartItems[index];
                final product = cartItem['product'];
                return _buildCartItem(
                  image: product['imageUrl'] ?? 'default_image_url',
                  name: product['name'] ?? 'Unknown Product',
                  description: product['description'],
                  price: product['price'].toString(),
                  quantity: cartItem['quantity'],
                  index: index,
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
    String? description,
    required String price,
    required int quantity,
    required int index,
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
                              'Description: ${description ?? 'No description available'}',
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
                            onPressed: quantity > 1
                                ? () {
                              setState(() {
                                _cartItems[index]['quantity'] -= 1;
                                _cartItems[index]['totalPrice'] =
                                    _cartItems[index]['product']['price'] *
                                        _cartItems[index]['quantity'];
                              });
                              _updateCartInFirebaseWithList(List.from(_cartItems));
                            }
                                : null,
                            iconSize: 18,
                          ),
                          Text('$quantity', style: const TextStyle(color: Colors.white)),
                          IconButton(
                            icon: const Icon(Icons.add, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                _cartItems[index]['quantity'] += 1;
                                _cartItems[index]['totalPrice'] =
                                    _cartItems[index]['product']['price'] *
                                        _cartItems[index]['quantity'];
                              });
                              _updateCartInFirebaseWithList(List.from(_cartItems));
                            },
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
              onPressed: () {
                final updatedCartItems = List<Map<String, dynamic>>.from(_cartItems)
                  ..removeAt(index);
                _updateCartInFirebaseWithList(updatedCartItems);
                setState(() {
                  _cartItems.removeAt(index);
                });
              },
              iconSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary() {
    // Calculate subtotal dynamically
    final double subtotal = _cartItems.fold(
      0.0,
          (sum, item) => sum + (item['totalPrice'] ?? 0.0),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          const Divider(color: Color(0xFF2C2C2E)),
          const SizedBox(height: 8),
          _buildSummaryRow(
            'Total',
            '\$${subtotal.toStringAsFixed(2)}',
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
        onPressed: () {
          // Handle checkout logic
        },
        child: const Text(
          'CHECKOUT',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
