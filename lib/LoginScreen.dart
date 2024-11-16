import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

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
          // Semi-transparent black overlay
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          // Content on top of the background image
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 60),
                // Back arrow icon
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context); // Define back action
                    },
                  ),
                ),
                SizedBox(height: 20),
                // Logo
                Center(
                  child: Column(
                    children: [
                      Image.asset("watchHub__1_-removebg-preview.png", width: 250, height: 150), // Replace with your logo
                      SizedBox(height: 10),
                      Text(
                        'Log in to your account',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                // Email TextField
                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[800]?.withOpacity(0.7),
                    hintText: 'steve_watson@yourdomain.com',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    prefixIcon: Icon(Icons.email, color: Colors.grey[500]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 20),
                // Password TextField
                TextField(
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[800]?.withOpacity(0.7),
                    hintText: '********',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    prefixIcon: Icon(Icons.lock, color: Colors.grey[500]),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey[500],
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 10),
                // Remember me checkbox
                Row(
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
                SizedBox(height: 20),
                // Log In button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3A4F7A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: () {
                    // Define Log In action
                  },
                  child: Text(
                    'Log in',
                    style: TextStyle(fontSize: 16, color: Colors.white),
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
                // Sign Up link
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // Define Sign Up action
                    },
                    child: Text(
                      'Don\'t have an account? Sign up',
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
