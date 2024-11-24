import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  String _selectedSize = '40 mm'; // Default selected size
  bool _isFavorited = false; // Default state for heart icon

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Close button and watch image
            Expanded(
              child: Stack(
                children: [
                  Center(
                    child: Image.asset(
                      'cart1.png', // Replace with your image URL or asset
                      fit: BoxFit.fill,
                    ),
                  ),
                  // Side pagination dots
                  Positioned(
                    right: 16,
                    top: MediaQuery.of(context).size.height / 4,
                    child: Column(
                      children: List.generate(
                        3,
                            (index) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: CircleAvatar(
                            radius: 4,
                            backgroundColor:
                            index == 0 ? Colors.white : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Close button
                  Positioned(
                    left: 16,
                    top: 16,
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.close, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            // Rounded details section
            Container(
              width: double.infinity, // Full width
              height: 250, // Height as per your existing design
              decoration: BoxDecoration(
                color: Color(0xFF212121), // Background color
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), // Subtle curve for top-left
                  topRight: Radius.circular(140), // Fine-tuned curve for smoothness
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0), // Increased vertical padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      'MOON 316L STAINLESS STEEL',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22, // Slightly larger font for prominence
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                    SizedBox(height: 12), // More spacing between title and price
                    // Price
                    Text(
                      '\$17,200 / Price Incl. all Taxes',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    SizedBox(height: 24), // Space before size options
                    // Size options
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start, // Align size options to the left
                      children: [
                        _sizeOption('35 mm', _selectedSize == '35 mm'),
                        SizedBox(width: 12), // Space between size options
                        _sizeOption('40 mm', _selectedSize == '40 mm'),
                        SizedBox(width: 12),
                        _sizeOption('45 mm', _selectedSize == '45 mm'),
                      ],
                    ),
                    SizedBox(height: 24), // Space before the button and icons
                    // Add to Bag button and icons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between button and icons
                      children: [
                        // ADD TO BAG button
                        Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFA9C5D9), // Light blue color from Figma
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 18), // Matches button height
                            ),
                            child: Text(
                              'ADD TO BAG',
                              style: TextStyle(
                                color: Colors.white, // White text color
                                fontSize: 18,
                                fontWeight: FontWeight.w100
                              ),
                            ),
                          ),
                        ),
                        // Icons
                        Row(
                          children: [
                            // Heart Icon
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _isFavorited = !_isFavorited; // Toggle favorite state
                                });
                              },
                              icon: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                transitionBuilder: (child, animation) {
                                  return ScaleTransition(
                                    scale: animation,
                                    child: child,
                                  );
                                },
                                child: Icon(
                                  _isFavorited ? IconlyBold.heart : IconlyLight.heart, // Thinner icons for filled and outlined heart
                                  key: ValueKey<bool>(_isFavorited),
                                  color: _isFavorited ? Colors.red : Colors.white, // Red when favorited
                                  size: 35, // Maintained size
                                ),
                              ),
                            ),
                            // Gap between icons
                            SizedBox(width: 12), // Adds a slightly larger gap between the icons
                            // Bag Icon
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                IconlyLight.bag, // Thinner bag icon
                                color: Colors.white,
                                size: 35, // Maintained size
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),


                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sizeOption(String size, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSize = size; // Update selected size
        });
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300), // Animation duration
        transitionBuilder: (Widget child, Animation<double> animation) {
          // Combine Fade and Slide transitions
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: Offset(0, 0.1), // Start slightly below
                end: Offset.zero, // End at the original position
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: Container(
          key: ValueKey<bool>(isSelected), // Unique key for state switching
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), // Compact size
          decoration: BoxDecoration(
            color: isSelected ? Color(0xFFA9C5D9) : Colors.black, // Background color transition
            borderRadius: BorderRadius.circular(8), // Rounded edges
          ),
          child: Center(
            child: Text(
              size,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70, // Animated text color
                fontSize: 15, // Matches the Figma font size
                fontWeight: FontWeight.w400, // Matches the Figma weight (400)
                letterSpacing: -0.3, // -2% letter spacing (approx -0.3 in Flutter)
                height: 1.0, // Matches line height of 15px in Figma
              ),
            ),
          ),
        ),
      ),
    );
  }



}
