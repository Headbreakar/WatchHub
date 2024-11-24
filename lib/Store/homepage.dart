import 'package:flutter/material.dart';
import 'package:flutterofflie/Store/category.dart';
import 'package:flutterofflie/Store/category.dart'; // Import your Trending page

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView( // Allow the entire page to scroll
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildAppBar(),
                SizedBox(height: 20),
                buildSearchBar(),
                SizedBox(height: 16),
                buildCategoryToggle(context),
                SizedBox(height: 20),
                Container(
                  height: MediaQuery.of(context).size.height * 0.7, // Grid takes up 70% of the screen height
                  child: buildWatchGrid(), // GridView scrolls independently
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBarWidget(),
    );
  }

  Widget buildAppBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            "watchHub__1_-removebg-preview.png",
            width: 150,
            height: 40,
            fit: BoxFit.contain,
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.favorite_border, color: Colors.white),
                onPressed: () {},
                tooltip: 'Favorite', // Accessibility label
              ),
              SizedBox(width: 8),
              CircleAvatar(
                backgroundImage: AssetImage("Profile_Image.png"),
                radius: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search Product",
        hintStyle: TextStyle(color: Colors.grey),
        prefixIcon: Icon(Icons.search, color: Colors.grey),
        filled: true,
        fillColor: Color(0xFF333333),
        contentPadding: EdgeInsets.symmetric(vertical: 12.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget buildCategoryToggle(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              // Redirect to TrendingPage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CategoryPage()), // Replace with your actual TrendingPage widget
              );
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Color(0xFF7EA1C1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Center(
                child: Text(
                  "Trending",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: () {
              // Redirect to CategoryPage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CategoryPage()),
              );
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Color(0xFF212121),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Center(
                child: Text(
                  "Category",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildWatchGrid() {
    return GridView.builder(
      physics: BouncingScrollPhysics(), // Smooth scrolling inside the grid
      itemCount: 4, // Replace with actual item count
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.55, // Slightly adjusted for better proportions
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        return buildWatchCard(
          "watchOne.png",
          "LOUIS MOINET MOON 316L",
          "\$17,200",
        );
      },
    );
  }

  Widget buildWatchCard(String imagePath, String name, String price) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double cardHeight = constraints.maxHeight; // Get available card height
        double imageHeight = cardHeight * 0.85; // Set image height to 85% of the card
        imageHeight = imageHeight.clamp(0, cardHeight - 50); // Avoid overflow by capping

        return Container(
          decoration: BoxDecoration(
            color: Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image section dynamically sized
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                child: Container(
                  height: imageHeight,
                  width: double.infinity,
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(Icons.error, color: Colors.red), // Placeholder for errors
                      );
                    },
                  ),
                ),
              ),
              // Text section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center, // Center text vertically
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      price,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class BottomNavigationBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, color: Colors.white),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.category, color: Colors.white),
          label: 'Categories',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings, color: Colors.white),
          label: 'Settings',
        ),
      ],
      selectedItemColor: Color(0xFF7EA1C1),
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    );
  }
}
