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
          IconButton(
            icon: Icon(Icons.tune, color: Colors.white),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (context) => buildFilterModal(context),
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

    final List<String> materials = [
      "Stainless Steel",
      "Gold",
      "Titanium",
      "Ceramic"
    ];
    final List<String> brands = [
      "Rolex",
      "Patek Philippe",
      "Omega",
      "Audemars Piguet"
    ];

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
              children: [
                Text(
                  "Filter Options",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),

                buildSectionTitle("Settings"),
                buildSwitchTile("Show Only New Arrivals", isSetting1, (value) {
                  setState(() => isSetting1 = value);
                }),
                buildSwitchTile(
                    "Show Only Premium Watches", isSetting2, (value) {
                  setState(() => isSetting2 = value);
                }),
                SizedBox(height: 16),

                buildSectionTitle("Price Range"),
                buildFilterChips(
                    priceRanges, selectedPriceRange, (selected, value) {
                  setState(() =>
                  selectedPriceRange = selected ? value : selectedPriceRange);
                }),
                SizedBox(height: 16),

                buildSectionTitle("Material"),
                buildFilterChips(
                    materials, selectedMaterial, (selected, value) {
                  setState(() =>
                  selectedMaterial = selected ? value : selectedMaterial);
                }),
                SizedBox(height: 16),

                buildSectionTitle("Brand"),
                buildFilterChips(brands, selectedBrand, (selected, value) {
                  setState(() =>
                  selectedBrand = selected ? value : selectedBrand);
                }),
                SizedBox(height: 16),

                buildSectionTitle("Hashtags"),
                buildFilterChips(hashtags, selectedHashtags, (selected, value) {
                  setState(() {
                    selectedHashtags[hashtags.indexOf(value)] = selected;
                  });
                }),

                SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF91AAC0),
                      padding: EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                        "Apply Filters", style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: Text(title, style: TextStyle(color: Colors.white)),
      activeColor: Color(0xFF91AAC0),
    );
  }

  Widget buildFilterChips(List<String> options, dynamic selectedOption,
      Function(bool, String) onSelected) {
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
      child: Wrap(
        spacing: 8.0,
        children: filters.map((filter) {
          return Chip(
            label: Text(
              filter,
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            backgroundColor: Color(0xFF333333),
            deleteIcon: Icon(Icons.close, size: 16, color: Colors.grey),
            onDeleted: () {
              // Handle filter removal
            },
          );
        }).toList(),
      ),
    );
  }

  Widget buildProductGrid() {
    final products = [
      {"title": "LOUIS MOINET MOON 316L", "price": "\$17,200", "image": "watchOne.png"},
      {"title": "ONLY INDIA 18K GOLD", "price": "\$286,248", "image": "watchTwo.png"},
      {"title": "MAEN Hudson 38 MK4", "price": "\$495", "image": "watchThree.png"},
      {"title": "Baume Mercier Riviera", "price": "\$4,028", "image": "watchFour.png"},
    ];

    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.55, // Adjusted for taller cards
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
        crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch content to fill card width
        children: [
          // Image section that covers most of the card
          Expanded(
            flex: 9, // Image takes 90% of the card height
            child: Container(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover, // Ensures the image fills the container
                  width: double.infinity,
                ),
              ),
            ),
          ),
          // Text section with minimal space
          Expanded(
            flex: 1, // Text takes 10% of the card height
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Centers text vertically
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
                    overflow: TextOverflow.ellipsis, // Handles long titles gracefully
                  ),
                  SizedBox(height: 4),
                  Text(
                    price,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


}
