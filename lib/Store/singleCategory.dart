import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SingleCategoryPage extends StatelessWidget {
  final String categoryId; // ID of the selected category
  final String categoryTitle;

  const SingleCategoryPage(
      {super.key, required this.categoryId, required this.categoryTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildAppBar(context),
            const SizedBox(height: 16),
            buildFilters(),
            const SizedBox(height: 16),
            Expanded(child: buildProductGrid()), // Fetch and display products
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add functionality for the cart button
        },
        backgroundColor: const Color(0xFF7EA1C1),
        child: const Icon(Icons.shopping_bag, color: Colors.white),
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
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Text(
                categoryTitle.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildFilters() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
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
    final DatabaseReference productsRef =
    FirebaseDatabase.instance.ref().child('products');

    print("Fetching products for categoryId: $categoryId");

    return FutureBuilder(
      future: productsRef
          .orderByChild('categoryId') // Query for categoryId
          .equalTo(categoryId) // Exact match
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF7EA1C1)),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Error: ${snapshot.error}",
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.value == null) {
          print("Fetched Data: No data found for categoryId: $categoryId");
          return const Center(
            child: Text(
              "No products available",
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        print("Fetched Data: ${snapshot.data!.value}"); // Debugging

        Map<dynamic, dynamic> productsMap =
        snapshot.data!.value as Map<dynamic, dynamic>;

        List products = productsMap.entries.map((entry) {
          return {
            "name": entry.value['name'],
            "price": entry.value['price'],
            "imageUrl": entry.value['imageUrl'],
            "shortDescription": entry.value['shortDescription'] ?? "",
            "longDescription": entry.value['longDescription'] ?? "",
          };
        }).toList();

        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.55,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            final product = products[index];
            return buildProductCard(
              product['name'],
              product['price'].toString(),
              product['imageUrl'],
              product['shortDescription'],
            );
          },
        );
      },
    );
  }


  Widget buildProductCard(String title, String price, String imageUrl,
      String shortDescription) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A), // Dark background color
        borderRadius: BorderRadius.circular(20), // Rounded corners
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.network(
              imageUrl,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 180,
                  color: Colors.grey[800],
                  child: const Center(
                    child: Icon(Icons.image_not_supported, color: Colors.red),
                  ),
                );
              },
            ),
          ),
          // Product Details
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 12.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title, // Product Name
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  "$price USD", // Product Price
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  shortDescription, // Short Description
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
    );
  }
}