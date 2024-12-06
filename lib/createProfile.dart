import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterofflie/LoginScreen.dart';

class CreateProfileScreen extends StatefulWidget {
  final String email;
  final String password;

  CreateProfileScreen({required this.email, required this.password});

  @override
  _CreateProfileScreenState createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  bool _isPasswordVisible = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();

  bool _showEmailHint = true;
  bool _showPasswordHint = true;

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email;
    _passwordController.text = widget.password;

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
    _passwordFocusNode.dispose();
    _nameFocusNode.dispose();
    _phoneFocusNode.dispose();
    _addressFocusNode.dispose();
    super.dispose();
  }

  Future<void> saveUserProfile() async {
    try {
      // Firebase Authentication: Create a user
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Get the newly created user's UID
      String userId = userCredential.user?.uid ?? '';

      // Save user data to Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'address': _addressController.text,
        'createdAt': FieldValue.serverTimestamp(),
        'isAdmin': false,
        'isVerified': false,
      });

      // Navigate to the login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      print('Error saving user data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save profile data: $e')),
      );
    }
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
                image: AssetImage("arm.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Blur effect with semi-transparent overlay
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
          // Main content with back button and title at the top
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20.0, right: 30.0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Spacer(),
                        Text(
                          'Fill your Profile',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
                Spacer(flex: 1),
                // Centered form content
                Center(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Image.asset(
                            "Profile_Image.png",
                            width: 350,
                            height: 250,
                          ),
                        ),
                        SizedBox(height: 20),
                        buildTextField(
                          hintText: 'Steve Watson',
                          icon: Icons.person,
                          focusNode: _nameFocusNode,
                          controller: _nameController,
                        ),
                        SizedBox(height: 20),
                        buildTextField(
                          hintText: 'steve_watson@yourdomain.com',
                          icon: Icons.email,
                          focusNode: _emailFocusNode,
                          showHint: _showEmailHint,
                          controller: _emailController,
                        ),
                        SizedBox(height: 20),
                        buildTextField(
                          hintText: '+1 111 856 783 997',
                          icon: Icons.phone,
                          focusNode: _phoneFocusNode,
                          controller: _phoneController,
                        ),
                        SizedBox(height: 20),
                        buildTextField(
                          hintText: '20845 Oakridge Farm Lane (NYC)',
                          icon: Icons.location_on,
                          focusNode: _addressFocusNode,
                          controller: _addressController,
                        ),
                        SizedBox(height: 20),
                        buildTextField(
                          hintText: '********',
                          icon: Icons.lock,
                          focusNode: _passwordFocusNode,
                          showHint: _showPasswordHint,
                          obscureText: !_isPasswordVisible,
                          controller: _passwordController,
                          suffixIcon: IconButton(
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
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                Spacer(flex: 4),
              ],
            ),
          ),
          // Sign Up button at the bottom with full width and padding
          Positioned(
            bottom: 30,
            left: 40,
            right: 40,
            child: buildButton(
              text: 'Continue',
              onPressed: saveUserProfile,
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build the text fields
  Widget buildTextField({
    required String hintText,
    required IconData icon,
    required FocusNode focusNode,
    bool obscureText = false,
    bool showHint = true,
    TextEditingController? controller,
    Widget? suffixIcon,
  }) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        child: StatefulBuilder(
          builder: (context, setState) {
            focusNode.addListener(() {
              setState(() {});
            });

            return TextField(
              focusNode: focusNode,
              controller: controller,
              obscureText: obscureText,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFF212121),
                hintText: focusNode.hasFocus ? null : hintText,
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.3),
                  fontWeight: FontWeight.w100,
                ),
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 15, right: 10),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                suffixIcon: suffixIcon,
                contentPadding: EdgeInsets.symmetric(vertical: 25),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: Colors.white),
            );
          },
        ),
      ),
    );
  }

  // Helper method to build the button
  Widget buildButton({required String text, required VoidCallback onPressed}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF7EA1C1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: EdgeInsets.symmetric(vertical: 25),
        minimumSize: Size(double.infinity, 60),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
          shadows: [
            Shadow(
              color: Color(0x66000000),
              offset: Offset(0, 1),
              blurRadius: 4,
            ),
          ],
        ),
      ),
    );
  }
}
