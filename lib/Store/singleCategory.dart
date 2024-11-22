import 'package:flutter/material.dart';

class SingleCategoryPage extends StatelessWidget {
  final String categoryTitle;

  SingleCategoryPage({required this.categoryTitle});

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
            buildProductGrid(),
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
                  Navigator.pop(context); // Navigate back to the previous screen
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
          IconButton(
            icon: Icon(Icons.tune, color: Colors.white),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (context) {
                  return buildFilterModal(context);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildFilterModal(BuildContext context) {
    final List<String> hashtags = ["Luxury", "Affordable", "New", "Trending"];
    final List<String> priceRanges = [
      "Under \$50",
      "\$50 - \$100",
      "\$100 - \$500",
      "\$500 - \$1000",
      "Over \$1000"
    ];

    final List<String> materials = ["Stainless Steel", "Gold", "Titanium", "Ceramic"];
    final List<String> brands = ["Rolex", "Patek Philippe", "Omega", "Audemars Piguet"];

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        bool isSetting1 = false;
        bool isSetting2 = true;
        List<bool> selectedHashtags = List<bool>.filled(hashtags.length, false);
        String selectedPriceRange = priceRanges[0];
        String selectedMaterial = materials[0];
        String selectedBrand = brands[0];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Filter Options",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 16),

                // Settings Section
                buildSectionTitle("Settings"),
                buildSwitchTile("Show Only New Arrivals", isSetting1, (value) {
                  setState(() {
                    isSetting1 = value;
                  });
                }),
                buildSwitchTile("Show Only Premium Watches", isSetting2, (value) {
                  setState(() {
                    isSetting2 = value;
                  });
                }),

                SizedBox(height: 16),

                // Price Range Section
                buildSectionTitle("Price Range"),
                buildFilterChips(priceRanges, selectedPriceRange, (selected, value) {
                  setState(() {
                    selectedPriceRange = selected ? value : selectedPriceRange;
                  });
                }),

                SizedBox(height: 16),

                // Material Filter Section
                buildSectionTitle("Material"),
                buildFilterChips(materials, selectedMaterial, (selected, value) {
                  setState(() {
                    selectedMaterial = selected ? value : selectedMaterial;
                  });
                }),

                SizedBox(height: 16),

                // Brand Filter Section
                buildSectionTitle("Brand"),
                buildFilterChips(brands, selectedBrand, (selected, value) {
                  setState(() {
                    selectedBrand = selected ? value : selectedBrand;
                  });
                }),

                SizedBox(height: 16),

                // Hashtags Section
                buildSectionTitle("Hashtags"),
                buildFilterChips(hashtags, selectedHashtags, (selected, value) {
                  setState(() {
                    selectedHashtags[hashtags.indexOf(value)] = selected;
                  });
                }),

                SizedBox(height: 24),

                // Apply Filters Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF91AAC0),
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text("Apply Filters", style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  // Reusable function for section titles
  Widget buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  // Reusable function for switch list tiles
  Widget buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: Text(title, style: TextStyle(color: Colors.white)),
      activeColor: Color(0xFF91AAC0),
    );
  }

  // Reusable function for filter chips (price ranges, materials, brands, hashtags)
  Widget buildFilterChips(List<String> options, dynamic selectedOption, Function(bool, String) onSelected) {
    return Wrap(
      spacing: 12.0,
      runSpacing: 8.0,
      children: List.generate(options.length, (index) {
        final isSelected = (selectedOption is List<bool>)
            ? selectedOption[index]
            : selectedOption == options[index];

        return FilterChip(
          label: Text(
            options[index],
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: isSelected ? Color(0xFF91AAC0) : Color(0xFF333333),
          selectedColor: Color(0xFF91AAC0),
          selected: isSelected,
          onSelected: (selected) {
            onSelected(selected, options[index]);
          },
        );
      }),
    );
  }



  Widget buildFilters() {
    final filters = ["new arrivals", "men"];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: filters.map((filter) {
          return Container(
            margin: EdgeInsets.only(right: 8.0),
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            decoration: BoxDecoration(
              color: Color(0xFF333333),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Text(
                  filter,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                SizedBox(width: 4.0),
                Icon(Icons.close, color: Colors.grey, size: 16),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget buildProductGrid() {
    // Mock product data
    final products = [
      {"title": "LOUIS MOINET MOON 316L", "price": "\$17,200", "image": "assets/watch1.png"},
      {"title": "ONLY INDIA 18K GOLD", "price": "\$286,248", "image": "assets/watch2.png"},
      {"title": "MAEN Hudson 38 MK4", "price": "\$495", "image": "assets/watch3.png"},
      {"title": "Baume Mercier Riviera", "price": "\$4,028", "image": "assets/watch4.png"},
    ];

    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemBuilder: (context, index) {
          final product = products[index];
          return buildProductCard(product["title"]!, product["price"]!, product["image"]!);
        },
      ),
    );
  }

  Widget buildProductCard(String title, String price, String imagePath) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(imagePath, fit: BoxFit.contain),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),
                Text(
                  price,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
