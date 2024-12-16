import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterofflie/Store/homepage.dart';
import 'package:flutterofflie/Store/mainscreen.dart';

class CheckoutPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  const CheckoutPage({Key? key, required this.cartItems}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String _deliveryAddress = 'Fetching address...'; // Placeholder for the address
  bool _isLoadingAddress = true; // Loading state for address

  @override
  void initState() {
    super.initState();
    _fetchDeliveryAddress(); // Fetch address on initialization
  }

  Future<void> _fetchDeliveryAddress() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          final data = userDoc.data();
          setState(() {
            _deliveryAddress = data?['address'] ?? 'No address found';
            _isLoadingAddress = false;
          });
        }
      }
    } catch (e) {
      print('Error fetching address: $e');
      setState(() {
        _deliveryAddress = 'Error fetching address';
        _isLoadingAddress = false;
      });
    }
  }

  Future<void> _updateDeliveryAddress(String newAddress) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'address': newAddress});

        setState(() {
          _deliveryAddress = newAddress;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Address updated successfully!',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('Error updating address: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Failed to update address!',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showEditAddressDialog() {
    TextEditingController addressController = TextEditingController(text: _deliveryAddress);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: const Text(
            'Edit Address',
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: addressController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Enter new address',
              hintStyle: TextStyle(color: Color(0xFF8E8E93)),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            TextButton(
              onPressed: () async {
                String newAddress = addressController.text.trim();
                if (newAddress.isNotEmpty) {
                  await _updateDeliveryAddress(newAddress); // Update address
                  Navigator.pop(context); // Close dialog
                }
              },
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDeliveryAddress() {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1C1C1E),
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(8),
        child: const Icon(Icons.location_on, color: Colors.white),
      ),
      title: Text(
        _isLoadingAddress ? 'Loading...' : _deliveryAddress,
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: const Text(
        'Tap to edit',
        style: TextStyle(color: Color(0xFF8E8E93)),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
      onTap: _showEditAddressDialog, // Open edit dialog
    );
  }

  Widget _buildPaymentMethods() {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1C1C1E),
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(8),
        child: const Icon(Icons.payment, color: Colors.white),
      ),
      title: const Text(
        'Cash on Delivery',
        style: TextStyle(color: Colors.white),
      ),
      subtitle: const Text(
        'Pay when the item is delivered',
        style: TextStyle(color: Color(0xFF8E8E93)),
      ),
      trailing: Radio(
        value: true,
        groupValue: true,
        onChanged: (value) {}, // No additional actions
        activeColor: Colors.blue,
      ),
    );
  }

  Widget _buildCartSummary(List<Map<String, dynamic>> cartItems) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final item = cartItems[index];
        final product = item['product'];

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C1E),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: Image.network(
              product['imageUrl'],
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(
              product['name'],
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            subtitle: Text(
              'Quantity: ${item['quantity']}',
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            trailing: Text(
              '\$${item['totalPrice'].toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTotal(double total) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Total:',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '\$${total.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayNowButton(BuildContext context, double total) {
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
        onPressed: () async {
          await _placeOrder(total);
        },
        child: const Text(
          'PAY NOW',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  Future<void> _placeOrder(double total) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        // Get a reference to the orders collection under the current user
        final ordersRef = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('orders');

        // Prepare the order data
        final orderData = {
          'createdAt': FieldValue.serverTimestamp(),
          'address': _deliveryAddress,
          'totalPrice': total,
          'items': widget.cartItems.map((item) {
            return {
              'productId': item['product']['id'],
              'name': item['product']['name'],
              'quantity': item['quantity'],
              'price': item['product']['price'],
              'totalPrice': item['totalPrice'],
            };
          }).toList(),
        };

        // Add the order to Firestore
        await ordersRef.add(orderData);

        // Clear the cart after placing the order
        await _clearCart(user.uid);

        // Show success popup
        _showOrderSuccessPopup();

      } catch (e) {
        print('Error placing order: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to place order. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You need to be logged in to place an order.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  Future<void> _clearCart(String userId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc('initialCart') // Assuming cart is stored in 'initialCart' document
          .delete();

      print('Cart cleared successfully.');
    } catch (e) {
      print('Error clearing cart: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to clear cart.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showOrderSuccessPopup() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent user from closing the popup manually
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.check_circle, color: Colors.green, size: 60),
              SizedBox(height: 16),
              Text(
                "Your order has been placed successfully!",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        );
      },
    );

    // Wait for 3 seconds and redirect to the homepage
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pop(); // Close the popup
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()), // Redirect to homepage
      );

    });
  }



  @override
  Widget build(BuildContext context) {
    double total = widget.cartItems.fold(
      0.0,
          (sum, item) => sum + (item['totalPrice'] ?? 0.0),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Checkout',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Delivery Address'),
          _buildDeliveryAddress(),
          _buildSectionTitle('Payment Method'),
          _buildPaymentMethods(),
          _buildSectionTitle('My Cart'),
          Expanded(child: _buildCartSummary(widget.cartItems)),
          const Divider(color: Color(0xFF2C2C2E)),
          _buildTotal(total),
          const SizedBox(height: 16),
          _buildPayNowButton(context, total),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
