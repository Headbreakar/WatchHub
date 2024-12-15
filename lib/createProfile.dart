import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON decoding
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'LoginScreen.dart';

class CreateProfileScreen extends StatefulWidget {
  final String email;
  final String password;

  const CreateProfileScreen({super.key, required this.email, required this.password});

  @override
  _CreateProfileScreenState createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final bool _isPasswordVisible = false;
  File? _selectedImage; // For mobile/desktop
  Uint8List? _webImage; // For Flutter Web
  final ImagePicker _picker = ImagePicker(); // ImagePicker instance
  final String imgbbApiKey = "d681de430ca3e38e4fd9b87a08a91f96"; // Replace with your ImgBB API key

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email;
    _passwordController.text = widget.password;
  }

  // Select an image using the ImagePicker
  Future<void> _selectImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        // For Flutter Web
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImage = bytes;
        });
      } else {
        // For Mobile/Desktop
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    }
  }

  // Upload the selected image to ImgBB
  Future<String?> _uploadImageToImgBB() async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse("https://api.imgbb.com/1/upload?key=$imgbbApiKey"),
      );

      if (kIsWeb) {
        // For web, send the image bytes
        request.files.add(http.MultipartFile.fromBytes(
          'image',
          _webImage!,
          filename: "profile.jpg",
        ));
      } else {
        // For mobile/desktop, send the image file
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          _selectedImage!.path,
        ));
      }

      final response = await request.send();
      final responseBody = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(responseBody.body);
        return jsonResponse["data"]["url"];
      } else {
        print("Error uploading to ImgBB: ${responseBody.body}");
        return null;
      }
    } catch (e) {
      print("Error during image upload: $e");
      return null;
    }
  }

  Future<void> saveUserProfile() async {
    try {
      // Firebase Authentication: Create a user
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Get the newly created user's UID
      String userId = userCredential.user?.uid ?? '';

      // Upload the profile image
      String? profileImageUrl = await _uploadImageToImgBB();

      // Save user data to Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'address': _addressController.text,
        'profileImageUrl': profileImageUrl,
        'createdAt': FieldValue.serverTimestamp(),
        'isAdmin': false,
        'isVerified': false,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile created successfully!')),
      );

      // Navigate to the login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
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
          // Background with blur effect
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("arm.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SafeArea(
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      const Text(
                        'Fill your Profile',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                const Spacer(flex: 1),
                // Profile Picture
                Center(
                  child: GestureDetector(
                    onTap: _selectImage,
                    child: CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.grey.shade800,
                      backgroundImage: kIsWeb
                          ? (_webImage != null ? MemoryImage(_webImage!) as ImageProvider<Object> : null)
                          : (_selectedImage != null ? FileImage(_selectedImage!) as ImageProvider<Object> : null),
                      child: (_webImage == null && _selectedImage == null)
                          ? const Icon(Icons.camera_alt, size: 40, color: Colors.white)
                          : null,
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                // Form Fields
                Center(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        buildTextField(
                          hintText: 'Steve Watson',
                          icon: Icons.person,
                          controller: _nameController,
                        ),
                        const SizedBox(height: 20),
                        buildTextField(
                          hintText: 'steve_watson@yourdomain.com',
                          icon: Icons.email,
                          controller: _emailController,
                        ),
                        const SizedBox(height: 20),
                        buildTextField(
                          hintText: '+1 111 856 783 997',
                          icon: Icons.phone,
                          controller: _phoneController,
                        ),
                        const SizedBox(height: 20),
                        buildTextField(
                          hintText: '20845 Oakridge Farm Lane (NYC)',
                          icon: Icons.location_on,
                          controller: _addressController,
                        ),
                        const SizedBox(height: 20),
                        buildTextField(
                          hintText: '********',
                          icon: Icons.lock,
                          controller: _passwordController,
                          obscureText: true,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                const Spacer(flex: 4),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            left: 40,
            right: 40,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7EA1C1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 25),
                minimumSize: const Size(double.infinity, 60),
              ),
              onPressed: saveUserProfile,
              child: const Text(
                'Continue',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField({
    required String hintText,
    required IconData icon,
    TextEditingController? controller,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF212121),
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.white.withOpacity(0.3),
        ),
        prefixIcon: Icon(icon, color: Colors.white),
        contentPadding: const EdgeInsets.symmetric(vertical: 25),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}
