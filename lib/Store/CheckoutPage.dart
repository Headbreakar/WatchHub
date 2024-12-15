import 'package:flutter/material.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          onPressed: () {},
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
          _buildCartSlider(), // Horizontal slider for "My Cart"
          const Divider(color: Color(0xFF2C2C2E)),
          _buildTotal(),
          const SizedBox(height: 16),
          _buildPayNowButton(),
          const SizedBox(height: 16),
        ],
      ),
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
      title: const Text(
        '20845 Oakridge Farm Lane',
        style: TextStyle(color: Colors.white),
      ),
      subtitle: const Text(
        'New York (NYC)',
        style: TextStyle(color: Color(0xFF8E8E93)),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
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
        child: const Icon(Icons.local_shipping, color: Colors.white),
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
        onChanged: (value) {}, // No action since only one option is present
        activeColor: Colors.blue,
      ),
    );
  }


  Widget _buildCartSlider() {
    return SizedBox(
      height: 200, // Adjust the height of the slider
      child: ListView(
        scrollDirection: Axis.horizontal, // Set horizontal scrolling
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildCartItem(
              image: 'cart1.png', name: 'MOON 316L STAINLESS STEEL', price: '17,200'),
          const SizedBox(width: 16),
          _buildCartItem(
              image: 'cart2.png', name: 'Astron Twin Time', price: '378,921'),
          const SizedBox(width: 16),
          _buildCartItem(
              image: 'cart3.png', name: 'Constellation Quartz 28 MM', price: '62,331'),
          const SizedBox(width: 16),
          _buildCartItem(
              image: 'cart3.png', name: 'Constellation Quartz 28 MM', price: '62,331'),
          const SizedBox(width: 16),
          _buildCartItem(
              image: 'cart3.png', name: 'Constellation Quartz 28 MM', price: '62,331'),
        ],
      ),
    );
  }

  Widget _buildCartItem(
      {required String image, required String name, required String price}) {
    return Container(
      width: 140, // Set a fixed width for each item
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '\$$price',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotal() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total :',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '\$458,500 USD',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayNowButton() {
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
          'PAY NOW',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
