import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:firebase_database/firebase_database.dart';

import '../Services/CartService.dart';
import 'CartPage.dart';

class ProductPage extends StatefulWidget {
  final String productId; // Pass productId dynamically

  const ProductPage({super.key, required this.productId});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage>
    with SingleTickerProviderStateMixin {
  String _selectedSize = '40 mm'; // Default selected size
  bool _isFavorited = false; // Default state for heart icon
  Map<String, dynamic>? _productData; // Store product data
  final CartService _cartService = CartService(); // CartService instance
  bool _isAddedToBag = false; // Track button state

  late AnimationController
      _animationController; // Animation controller for scaling
  late Animation<double> _scaleAnimation; // Scale animation

  @override
  void initState() {
    super.initState();
    _fetchProductDetails();

    // Initialize the animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Define the scale animation
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Fetch product details from Firebase
  Future<void> _fetchProductDetails() async {
    try {
      DatabaseReference productRef = FirebaseDatabase.instance
          .ref()
          .child('products')
          .child(widget.productId);

      final snapshot = await productRef.once();

      if (snapshot.snapshot.value != null) {
        setState(() {
          _productData = Map<String, dynamic>.from(
              (snapshot.snapshot.value as Map<dynamic, dynamic>).map(
            (key, value) => MapEntry(key.toString(), value),
          ));
        });
      } else {
        print("Error: No data found for the given product ID.");
      }
    } catch (e) {
      print("Error fetching product details: $e");
    }
  }

  void _toggleWishlist() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle unauthenticated user
      print("User not authenticated");
      return;
    }

    final String userId = user.uid;

    try {
      final wishlistRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('wishlist')
          .doc('initialWishlist');

      final wishlistSnapshot = await wishlistRef.get();

      if (wishlistSnapshot.exists) {
        final List<dynamic> items = wishlistSnapshot['items'] ?? [];

        if (_isFavorited) {
          // Remove item from wishlist
          items.removeWhere((item) => item['id'] == widget.productId);
        } else {
          // Add item to wishlist
          items.add({
            'id': widget.productId,
            'name': _productData!['name'],
            'price': _productData!['price'],
            'imageUrl': _productData!['imageUrl'],
          });
        }

        // Update the wishlist in Firestore
        await wishlistRef.update({'items': items});
      } else {
        // Create a new wishlist document if it doesn't exist
        await wishlistRef.set({
          'items': [
            {
              'id': widget.productId,
              'name': _productData!['name'],
              'price': _productData!['price'],
              'imageUrl': _productData!['imageUrl'],
            }
          ],
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      // Toggle the favorite state
      setState(() {
        _isFavorited = !_isFavorited;
      });
    } catch (e) {
      print("Error updating wishlist: $e");
    }
  }

  void _addToCart() async {
    if (_productData != null) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // Handle unauthenticated user
        print("User not authenticated");
        return;
      } else {
        final String userId = user.uid;

        // Ensure the price is a double
        double price = 0.0;
        if (_productData!['price'] is String) {
          price = double.tryParse(_productData!['price']) ?? 0.0;
        } else if (_productData!['price'] is double) {
          price = _productData!['price'];
        }

        // Add product to cart
        await _cartService.addItemToCart(
          userId,
          widget.productId,
          _productData!['name'],
          price,
        );

        // Start the animation
        setState(() {
          _isAddedToBag = true;
        });

        _animationController.forward();

        // Reset button state after a short delay
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            _isAddedToBag = false;
          });
          _animationController.reverse();
        });

        print('Product added to cart');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: _productData == null
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : Column(
                children: [
                  // Close button and product image
                  Expanded(
                    child: Stack(
                      children: [
                        Center(
                          child: Image.network(
                            _productData![
                                'imageUrl'], // Dynamically loaded image
                            fit: BoxFit.fill,
                            height: 500,
                          ),
                        ),
                        // Side pagination dots
                        Positioned(
                          right: 16,
                          top: MediaQuery.of(context).size.height / 4,
                          child: Column(
                            children: List.generate(
                              3,
                              (index) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: CircleAvatar(
                                  radius: 4,
                                  backgroundColor:
                                      index == 0 ? Colors.white : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Close button
                        Positioned(
                          left: 16,
                          top: 16,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.close, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Rounded details section
                  Container(
                    width: double.infinity,
                    height: 250,
                    decoration: const BoxDecoration(
                      color: Color(0xFF212121),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(140),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            _productData!['name'] ?? 'Product Name',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Price
                          Text(
                            '\$${_productData!['price']} / Price Incl. all Taxes',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Size options
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _sizeOption('35 mm', _selectedSize == '35 mm'),
                              const SizedBox(width: 12),
                              _sizeOption('40 mm', _selectedSize == '40 mm'),
                              const SizedBox(width: 12),
                              _sizeOption('45 mm', _selectedSize == '45 mm'),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Add to Bag button and icons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // ADD TO BAG button
                              ScaleTransition(
                                scale: _scaleAnimation,
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  transitionBuilder: (Widget child,
                                      Animation<double> animation) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    );
                                  },
                                  child: _isAddedToBag
                                      ? _buildAddedButton()
                                      : _buildAddToBagButton(),
                                ),
                              ),

                              // Icons
                              Row(
                                children: [
                                  // Heart Icon
                                  IconButton(
                                    onPressed: _toggleWishlist,
                                    icon: AnimatedSwitcher(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      transitionBuilder: (child, animation) {
                                        return ScaleTransition(
                                          scale: animation,
                                          child: child,
                                        );
                                      },
                                      child: Icon(
                                        _isFavorited
                                            ? IconlyBold.heart
                                            : IconlyLight.heart,
                                        key: ValueKey<bool>(_isFavorited),
                                        color: _isFavorited
                                            ? Colors.red
                                            : Colors.white,
                                        size: 35,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 12),
                                  // Bag Icon
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const CartPage(), // Replace with your CartPage widget
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                      IconlyLight.bag,
                                      color: Colors.white,
                                      size: 35,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildAddToBagButton() {
    return ElevatedButton(
      key: const ValueKey("addToBagButton"), // Key for AnimatedSwitcher
      onPressed: _addToCart,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFA9C5D9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 32),
      ),
      child: const Text(
        'ADD TO BAG',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w100,
        ),
      ),
    );
  }

  Widget _buildAddedButton() {
    return ElevatedButton.icon(
      key: const ValueKey("addedButton"),
      // Key for AnimatedSwitcher
      onPressed: null,
      // Disable button
      icon: const Icon(
        Icons.check,
        color: Colors.white,
        size: 20,
      ),
      label: const Text(
        'ADDED!',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w100,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 32),
      ),
    );
  }

  Widget _sizeOption(String size, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSize = size;
        });
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
                  .animate(animation),
              child: child,
            ),
          );
        },
        child: Container(
          key: ValueKey<bool>(isSelected),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFA9C5D9) : Colors.black,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              size,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontSize: 15,
                fontWeight: FontWeight.w400,
                letterSpacing: -0.3,
                height: 1.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
