import 'package:flutter/material.dart';

void main() {
  runApp(WatchEaseApp());
}

class WatchEaseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WatchEaseScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WatchEaseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background image of the arm and watch
          Positioned.fill(
            child: Opacity(
              opacity: 0.8, // Adjust opacity if needed
              child: Image.asset(
                'arm.png', // Make sure to add the image to your assets
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Logo and Text Content
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo and app name
                Padding(
                  padding: const EdgeInsets.only(bottom: 50.0),
                  child: Column(
                    children: [
                      Image.asset(
                        'watchHub__1_-removebg-preview.png', // Add your logo image in assets
                        width: 300,
                        height: 150,
                      ),
                      SizedBox(height: 8),
                      // Text(
                      //   'WATCHEASE',
                      //   style: TextStyle(
                      //     color: Colors.white,
                      //     fontSize: 24,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                    ],
                  ),
                ),
                // Main description text
                Text(
                  'Explore the watchease here',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'The best watch app in your device.\nAnswer of watchkeeper to find their watch',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[300],
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 30),
                // Button for "Create an account"
                Container(
                  width: 200,
                  child: ElevatedButton(

                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.only(right: 30.0, left: 30.0, top: 20.0, bottom: 20.0),
                      backgroundColor: Color(0xFF3A4F7A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      // Define what happens when pressed
                    },
                    child: Text(
                      'Create an account',
                      style: TextStyle(fontSize: 16,color: Colors.white),
                    ),
                  ),
                ),
                // Already have an account text
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    // Define what happens when pressed
                  },
                  child: Text(
                    'Already have an account?',
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                    ),
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
