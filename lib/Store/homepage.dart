import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
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
              buildSearchBar(),
              buildCategoryToggle(context),
              SizedBox(height: 16),
              buildWatchGrid(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBarWidget(),
    );
  }

  Widget buildAppBar() {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            "watchHub__1_-removebg-preview.png",
            width: 200,
            height: 40,
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.favorite_border, color: Colors.white),
                onPressed: () {},
              ),
              CircleAvatar(
                backgroundImage: AssetImage("Profile_Image.png"), // Replace with your image path
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: TextField(
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
      ),
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
                // Handle "Trending" toggle
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: true ? Color(0xFF7EA1C1) : Color(0xFF212121), // Change 'true' to selected condition
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                ),
                child: Center(
                  child: Text(
                    "Trending",
                    style: TextStyle(color: Colors.white,fontSize: 20),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 15), // Space between buttons
          Expanded(
            child: GestureDetector(
              onTap: () {

              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: false ? Color(0xFF3A4F7A) : Color(0xFF212121), // Change 'false' to selected condition
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                ),
                child: Center(
                  child: Text(
                    "Category",
                    style: TextStyle(color: Colors.white,fontSize: 20),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }




  Widget buildWatchGrid() {
    return Expanded(
      child: GridView.builder(
        itemCount: 4, // Replace with your actual item count
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemBuilder: (context, index) {
          return buildWatchCard();
        },
      ),
    );
  }

  Widget buildWatchCard() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/watch_image.png", height: 100), // Replace with actual image
          SizedBox(height: 8),
          Text(
            "LOUIS MOINET MOON 316L",
            style: TextStyle(color: Colors.white, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          Text(
            "\$17,200",
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
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
