import 'package:flutter/material.dart';
import 'package:flutterofflie/Store/homepage.dart';
import 'package:flutterofflie/Store/singleCategory.dart';


class CategoryPage extends StatelessWidget {
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
              buildAppBar(),
              SizedBox(height: 16),
              buildSearchBar(),
              SizedBox(height: 16),
              buildCategoryToggle(context),
              SizedBox(height: 16),
              Expanded(
                child: buildCategoryList(context),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBarWidget(),
    );
  }

  Widget buildCategoryToggle(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: false ? Color(0xFF7EA1C1) : Color(0xFF212121), // "Trending" unselected
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                ),
                child: Center(
                  child: Text(
                    "Trending",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 15), // Space between buttons
          Expanded(
            child: GestureDetector(
              onTap: () {
                // "Category" is already selected, so no action needed
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: true ? Color(0xFF7EA1C1) : Color(0xFF212121), // "Category" selected
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                ),
                child: Center(
                  child: Text(
                    "Category",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAppBar() {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
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
                icon: Icon(Icons.favorite_border, color: Colors.white),
                onPressed: () {},
              ),
              CircleAvatar(
                backgroundImage: AssetImage("Profile_Image.png"),
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget buildCategoryList(BuildContext context) {
    final categories = [
      {"title": "LOUIS MOINET WATCHES", "image": "cat.png"},
      {"title": "TRENDING FOR MEN", "image": "catTwo.png"},
      {"title": "TRENDING FOR WOMEN", "image": "women_watches1.png"},
      {"title": "TRENDING FOR KIDS", "image": "bgWatch.png"},
    ];

    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return GestureDetector(
          onTap: () {
            // Navigate to the Single Category Page with the selected category
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SingleCategoryPage(
                  categoryTitle: category["title"]!,
                ),
              ),
            );
          },
          child: buildCategoryCard(category["title"]!, category["image"]!),
        );
      },
    );
  }

  Widget buildCategoryCard(String title, String imagePath) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      height: 150,
      alignment: Alignment.center,
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
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
          label: 'HOME',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.category, color: Colors.white),
          label: 'CATEGORIES',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings, color: Colors.white),
          label: 'SETTINGS',
        ),
      ],
      selectedItemColor: Color(0xFF3A4F7A),
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
    );
  }
}
