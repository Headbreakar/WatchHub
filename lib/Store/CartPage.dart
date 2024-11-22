import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

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
          'Close',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildCartItem(
                  image: 'cart1.png',
                  name: 'MOON 316L STAINLESS STEEL',
                  size: '40 mm',
                  price: '17,200',
                ),
                _buildCartItem(
                  image: 'cart1.png',
                  name: 'Astronef Twin-Tourbillon',
                  size: '45 mm',
                  price: '378,921',
                ),
                _buildCartItem(
                  image: 'cart1.png',
                  name: 'Constellation Quartz 28 MM',
                  size: '28 mm',
                  price: '62,331',
                ),
              ],
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
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E), // Grayish background
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          // Image and Product Details
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 80, // Set width to 80
                  height: 112, // Set height to 112
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: AssetImage(image),
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
                        padding: const EdgeInsets.only(left: 12.0), // Add left padding here
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
                                color: Color(0xFF8E8E93), // Subtle gray
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
                          const Text('1', style: TextStyle(color: Colors.white)),
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
          // Positioned delete icon at top left corner
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
          backgroundColor: const Color(0xFF007AFF), // iPhone-style blue
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
