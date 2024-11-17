import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutterofflie/LoginScreen.dart';
import 'package:flutterofflie/createProfile.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // Focus nodes for each TextField
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  // Flags to control hint visibility
  bool _showEmailHint = true;
  bool _showPasswordHint = true;

  @override
  void initState() {
    super.initState();

    // Set up listeners for focus changes
    _emailFocusNode.addListener(() {
      setState(() {
        _showEmailHint = !_emailFocusNode.hasFocus;
      });
    });

    _passwordFocusNode.addListener(() {
      setState(() {
        _showPasswordHint = !_passwordFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("arm.png"), // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Blur effect with semi-transparent overlay
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Adjust blur strength
              child: Container(
                color: Colors.black.withOpacity(0.5), // Semi-transparent overlay to enhance blur effect
              ),
            ),
          ),
          // Content on top of the blurred background
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20),
                // Back arrow icon at the top
                SafeArea(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context); // Define back action
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Logo positioned in the center below the back icon
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        "watchHub__1_-removebg-preview.png", // Replace with your logo
                        width: 350, // Adjust width as needed
                        height: 200, // Adjust height as needed
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Create your account',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                // Email TextField with hint hiding on focus
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.85, // Adjusted width to 85% of screen width
                    child: TextField(
                      controller: _emailController,
                      focusNode: _emailFocusNode,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xFF212121), // Solid background color
                        hintText: _showEmailHint ? 'steve_watson@yourdomain.com' : null, // Conditional hint text
                        hintStyle: TextStyle(color: Colors.white),
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(left: 15, right: 10),
                          child: Icon(Icons.email, color: Colors.white),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 25), // Increased vertical padding
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Password TextField with hint hiding on focus
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.85, // Adjusted width to 85% of screen width
                    child: TextField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      focusNode: _passwordFocusNode,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xFF212121), // Solid background color
                        hintText: _showPasswordHint ? '********' : null, // Conditional hint text

                        hintStyle: TextStyle(color: Colors.white),
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(left: 15, right: 10),
                          child: Icon(Icons.lock, color: Colors.white),
                        ),
                        suffixIcon: Padding(
                          padding: EdgeInsets.only(right: 20), // Padding around the suffix icon
                          child: IconButton(
                            icon: Icon(
                              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 25), // Increased vertical padding
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // Centered Remember me checkbox
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        activeColor: Colors.lightBlueAccent,
                        onChanged: (value) {
                          setState(() {
                            _rememberMe = value!;
                          });
                        },
                      ),
                      Text(
                        'Remember me',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // Sign Up button
                Center(
                  child: Container(
                    width: 420, // Set the desired width here
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF7EA1C1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 25),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateProfileScreen(
                              email: _emailController.text,
                              password: _passwordController.text,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Color(0x66000000), // #00000040 (40% opacity)
                              offset: Offset(0, 1), // x: 0px, y: 1px
                              blurRadius: 4, // Blur radius of 4px
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),
                // "or continue with" text
                Center(
                  child: Text(
                    'or continue with',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ),
                SizedBox(height: 20),
                // Social media icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.facebook, color: Colors.blue, size: 40),
                      onPressed: () {
                        // Define Facebook login action
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.g_mobiledata, color: Colors.red, size: 40), // Example for Google icon
                      onPressed: () {
                        // Define Google login action
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.apple, color: Colors.white, size: 40),
                      onPressed: () {
                        // Define Apple login action
                      },
                    ),
                  ],
                ),
                Spacer(),
                // Sign In link
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Text(
                      'Already have an account? Sign in',
                      style: TextStyle(
                        color: Colors.grey[500],
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
