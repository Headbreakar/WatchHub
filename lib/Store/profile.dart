import 'dart:io';
import 'dart:convert'; // For JSON decoding
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import '../LoginScreen.dart'; // For kIsWeb

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Map<String, dynamic>?> _userData;

  @override
  void initState() {
    super.initState();
    _userData = _fetchUserData();
  }

  Future<void> _updateProfileImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    File? selectedImage;
    Uint8List? webImage;
    const String imgbbApiKey = "d681de430ca3e38e4fd9b87a08a91f96"; // Replace with your ImgBB API key

    try {
      // Pick an image
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;

      // Check if it's a web app or mobile
      if (kIsWeb) {
        webImage = await pickedFile.readAsBytes();
      } else {
        selectedImage = File(pickedFile.path);
      }

      // Upload the image to ImgBB
      String? uploadedImageUrl = await _uploadImageToImgBB(
        webImage: webImage,
        file: selectedImage,
        imgbbApiKey: imgbbApiKey,
      );

      if (uploadedImageUrl != null) {
        // Update Firestore with the new image URL
        final userId = FirebaseAuth.instance.currentUser?.uid;
        if (userId != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .update({'profileImageUrl': uploadedImageUrl});

          // Refresh user data
          setState(() {
            _userData = _fetchUserData();
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile image updated successfully!')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload profile image.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred while updating the image.')),
      );
      print("Error updating profile image: $e");
    }
  }

  Future<String?> _uploadImageToImgBB({
    Uint8List? webImage,
    File? file,
    required String imgbbApiKey,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse("https://api.imgbb.com/1/upload?key=$imgbbApiKey"),
      );

      if (kIsWeb) {
        request.files.add(http.MultipartFile.fromBytes(
          'image',
          webImage!,
          filename: "profile.jpg",
        ));
      } else {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          file!.path,
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

  Future<Map<String, dynamic>?> _fetchUserData() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return null;

      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      return userDoc.data();
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text(
                'Error fetching profile data',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final userData = snapshot.data!;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildProfileHeader(context, userData),
                  const SizedBox(height: 20),
                  buildSectionTitle('Account Information'),
                  buildAccountInfoList(context, userData),
                  const SizedBox(height: 20),
                  buildSectionTitle('Settings'),
                  buildSettingsList(),
                  const SizedBox(height: 20),
                  buildSectionTitle('Order History'),
                  buildOrderHistory(),
                  const SizedBox(height: 40),
                  buildLogoutButton(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildProfileHeader(BuildContext context, Map<String, dynamic> userData) {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: () async {
              await _updateProfileImage(context);
              // Refresh only the user data without creating a new page instance
              setState(() {
                _userData = _fetchUserData();
              });
            },
            child: CircleAvatar(
              radius: 70,
              backgroundColor: Colors.grey.shade800,
              backgroundImage: userData['profileImageUrl'] != null
                  ? NetworkImage(userData['profileImageUrl'])
                  : const AssetImage("profile_image.png") as ImageProvider,
              child: userData['profileImageUrl'] == null
                  ? const Icon(Icons.camera_alt, size: 40, color: Colors.white)
                  : null,
            ),
          ),

          const SizedBox(height: 16),
          Text(
            userData['name'] ?? 'Name not available',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            userData['email'] ?? 'Email not available',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget buildAccountInfoList(BuildContext context, Map<String, dynamic> userData) {
    return Column(
      children: [
        buildListItem(
          Icons.phone,
          "Phone: ${userData['phone'] ?? 'N/A'}",
          onTap: () {
            // Navigate to UpdateFieldScreen for Phone
          },
        ),
        buildListItem(
          Icons.location_on,
          "Address: ${userData['address'] ?? 'N/A'}",
          onTap: () {
            // Navigate to UpdateFieldScreen for Address
          },
        ),
      ],
    );
  }

  Widget buildSettingsList() {
    return Column(
      children: [
        buildListItem(Icons.notifications, "Notifications"),
        buildListItem(Icons.security, "Privacy & Security"),
        buildListItem(Icons.help, "Help Center"),
      ],
    );
  }

  Widget buildOrderHistory() {
    return Column(
      children: [
        buildListItem(Icons.shopping_bag, "View All Orders"),
        buildListItem(Icons.access_time, "Track Orders"),
      ],
    );
  }

  Widget buildLogoutButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () async {
          try {
            await FirebaseAuth.instance.signOut();

            // Use pushAndRemoveUntil to clear the navigation stack
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false, // Remove all routes
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error during logout. Please try again.')),
            );
            print("Logout error: $e");
          }
        },

        child: const Text(
          "LOGOUT",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }


  Widget buildListItem(IconData icon, String title, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }
}
