import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  final DatabaseReference categoriesRef =
  FirebaseDatabase.instance.ref().child('categories');

  final VoidCallback onCartUpdate; // Callback to notify parent when cart is updated

  CategoryPage({super.key, required this.onCartUpdate}); // Constructor to pass the callback

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Bar
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "CATEGORY",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.favorite_border, color: Colors.white),
                          onPressed: () {},
                        ),
                        const CircleAvatar(
                          backgroundImage: AssetImage("Profile_Image.png"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: "Search Product",
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFF333333),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Toggle Buttons
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 50,
                          decoration: const BoxDecoration(
                            color: Color(0xFF212121), // "Trending" unselected
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                          ),
                          child: const Center(
                            child: Text(
                              "Trending",
                              style:
                              TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15), // Space between buttons
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // "Category" is already selected, so no action needed
                        },
                        child: Container(
                          height: 50,
                          decoration: const BoxDecoration(
                            color: Color(0xFF7EA1C1), // "Category" selected
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                          ),
                          child: const Center(
                            child: Text(
                              "Category",
                              style:
                              TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Categories List
              Expanded(
                child: FutureBuilder(
                  future: categoriesRef.get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(
                          child: Text("Error fetching categories.",
                              style: TextStyle(color: Colors.white)));
                    } else if (snapshot.hasData) {
                      Map<dynamic, dynamic>? data =
                      snapshot.data!.value as Map<dynamic, dynamic>?;
                      if (data == null || data.isEmpty) {
                        return const Center(
                            child: Text("No categories found.",
                                style: TextStyle(color: Colors.white)));
                      }

                      List categories = data.entries
                          .map((entry) => {
                        "id": entry.key, // Category ID
                        "title": entry.value['name'] ?? "Unknown",
                        "image": _getImage(entry.key), // Default image
                      })
                          .toList();

                      return ListView.builder(
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          return GestureDetector(
                            onTap: () {
                              // Example: Add category to cart logic here
                              print("Added to cart: ${category['title']}");

                              // Notify the parent that the cart has been updated
                              onCartUpdate();
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  image: AssetImage(category["image"]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              height: 150,
                              alignment: Alignment.center,
                              child: Text(
                                category["title"],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return const Center(
                        child: Text("Unexpected error occurred.",
                            style: TextStyle(color: Colors.white)));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getImage(String key) {
    final defaultImages = [
      "cat.png",
      "catTwo.png",
      "women_watches1.png",
      "bgWatch.png"
    ];
    int index = int.tryParse(key) ?? 0;
    return defaultImages[index % defaultImages.length];
  }
}
