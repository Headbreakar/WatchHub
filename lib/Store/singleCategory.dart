import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SingleCategoryPage extends StatelessWidget {
  final String categoryId; // ID of the selected category
  final String categoryTitle;

  SingleCategoryPage({required this.categoryId, required this.categoryTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildAppBar(context),
            SizedBox(height: 16),
            buildFilters(),
            SizedBox(height: 16),
            Expanded(child: buildProductGrid()), // Fetch and display products
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add functionality for the cart button
        },
        backgroundColor: Color(0xFF7EA1C1),
        child: Icon(Icons.shopping_bag, color: Colors.white),
      ),
    );
  }

  Widget buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
      Row(
      children: [
      IconButton(
      icon: Icon(Icons.arrow_back, color: Colors.white),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
    Text(
    categoryTitle.toUpperCase(),
    style: TextStyle(
    color: Colors.white,
    fontSize: 22,
    fontWeight: FontWeight.bold,
    ),
    ),
    ],
    ),
  ],),);

  }

  Widget buildFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Wrap(
        spacing: 8.0,
        children: [
          Chip(
            label: Text(
              "New Arrivals",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            backgroundColor: Color(0xFF333333),
          ),
        ],
      ),
    );
  }

  Widget buildProductGrid() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('products')
          .where('categoryId', isEqualTo: categoryId) // Make sure categoryId is passed correctly
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: Color(0xFF7EA1C1)),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              "No products available",
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        final products = snapshot.data!.docs;

        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.55,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            final product = products[index].data() as Map<String, dynamic>;
            return buildProductCard(
              product['name'],
              product['price'],
              product['imageUrl'],
              product['shortDescription'] ?? "", // Default to empty string if no shortDescription
              product['longDescription'] ?? "", // Include longDescription if needed
            );
          },
        );
      },
    );
  }


  Widget buildProductCard(String title, String price, String imageUrl, String shortDescription, String longDescription) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 9,
            child: Container(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    "\$${price}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    shortDescription,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // You can add longDescription or any other info if needed
                  // Text(
                  //   longDescription,
                  //   style: TextStyle(color: Colors.white, fontSize: 10),
                  //   maxLines: 2,
                  //   overflow: TextOverflow.ellipsis,
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
