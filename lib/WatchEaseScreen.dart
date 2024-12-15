import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutterofflie/SignUpScreen.dart';
import 'package:flutterofflie/LoginScreen.dart';

class WatchEaseScreen extends StatelessWidget {
  const WatchEaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background image of the arm and watch
          Positioned.fill(
            child: Opacity(
              opacity: 0.7, // Adjusted opacity for darker effect
              child: Image.asset(
                'arm.png', // Make sure to add the image to your assets
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Logo and Text Content
          Positioned.fill(
            child: Column(
              children: [
                // Logo positioned at the top
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Image.asset(
                    'watchHub__1_-removebg-preview.png', // Add your logo image in assets
                    width: 200, // Adjusted width
                    height: 100, // Adjusted height
                  ),
                ),
                const Spacer(), // Pushes main text block to the bottom
                // Main description text and button positioned at the bottom
                Padding(
                  padding: const EdgeInsets.only(bottom: 60.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Blur effect
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9, // Adjust width to 90% of screen width
                        padding: const EdgeInsets.all(20), // Padding inside the container
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3), // Semi-transparent black background
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1), // Light border for glass effect
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Explore the watchease here',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22, // Slightly increased font size
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'The best watch app in your device.\nAnswer of watchkeeper to find their watch',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey[200], // Lighter shade for better contrast
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 30),
                            // Button for "Create an account"
                            SizedBox(
                              width: 300,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20), // Adjusted padding
                                  backgroundColor: const Color(0xFF3A4F7A).withOpacity(0.5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const SignUpScreen()),
                                  );
                                },
                                child: const Text(
                                  'Create an account',
                                  style: TextStyle(fontSize: 16, color: Colors.white),
                                ),
                              ),
                            ),
                            // Already have an account text
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                // Navigate to login screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const LoginScreen()), // Replace with actual LoginScreen widget
                                );
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
