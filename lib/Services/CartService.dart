import 'package:cloud_firestore/cloud_firestore.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add item to cart
  Future<void> addItemToCart(String userId, String productId, String productName, double price) async {
    try {
      DocumentReference cartRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc('initialCart');

      DocumentSnapshot cartSnapshot = await cartRef.get();

      // If the cart document doesn't exist, create it
      if (!cartSnapshot.exists) {
        await cartRef.set({
          'items': [],
          'totalPrice': 0.0,
        });
      }

      List<dynamic> items = cartSnapshot['items'] ?? [];
      double totalPrice = cartSnapshot['totalPrice'] ?? 0.0;

      bool productExists = false;
      for (var item in items) {
        if (item['id'] == productId) {
          item['quantity'] += 1;
          productExists = true;
          break;
        }
      }

      if (!productExists) {
        items.add({
          'id': productId,
          'name': productName,
          'quantity': 1,
          'price': price,
        });
      }

      totalPrice = 0.0;
      for (var item in items) {
        totalPrice += item['price'] * item['quantity'];
      }

      await cartRef.update({
        'items': items,
        'totalPrice': totalPrice,
      });

      print('Item added to cart successfully!');
    } catch (e) {
      print('Error adding item to cart: $e');
    }
  }


  // Remove item from cart
  Future<void> removeItemFromCart(String userId, String productId) async {
    try {
      // Get the current cart document
      DocumentReference cartRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc('initialCart');

      // Get the current cart data
      DocumentSnapshot cartSnapshot = await cartRef.get();

      // If cart doesn't exist, return
      if (!cartSnapshot.exists) return;

      // Get the current cart items and total price
      List<dynamic> items = cartSnapshot['items'] ?? [];
      double totalPrice = cartSnapshot['totalPrice'] ?? 0.0;

      // Remove the item from the cart
      items.removeWhere((item) => item['id'] == productId);

      // Recalculate the total price
      totalPrice = 0.0;
      for (var item in items) {
        totalPrice += item['price'] * item['quantity'];
      }

      // Update Firestore with new cart data
      await cartRef.update({
        'items': items,
        'totalPrice': totalPrice,
      });

      print('Item removed from cart successfully!');
    } catch (e) {
      print('Error removing item from cart: $e');
    }
  }

  // Update item quantity in cart
  Future<void> updateItemQuantity(String userId, String productId, int quantity) async {
    try {
      // Get the current cart document
      DocumentReference cartRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc('initialCart');

      // Get the current cart data
      DocumentSnapshot cartSnapshot = await cartRef.get();

      // If cart doesn't exist, return
      if (!cartSnapshot.exists) return;

      // Get the current cart items and total price
      List<dynamic> items = cartSnapshot['items'] ?? [];
      double totalPrice = cartSnapshot['totalPrice'] ?? 0.0;

      // Find the item and update its quantity
      for (var item in items) {
        if (item['id'] == productId) {
          item['quantity'] = quantity;  // Update the quantity
          break;
        }
      }

      // Recalculate the total price
      totalPrice = 0.0;
      for (var item in items) {
        totalPrice += item['price'] * item['quantity'];
      }

      // Update Firestore with new cart data
      await cartRef.update({
        'items': items,
        'totalPrice': totalPrice,
      });

      print('Item quantity updated successfully!');
    } catch (e) {
      print('Error updating item quantity: $e');
    }
  }
}
