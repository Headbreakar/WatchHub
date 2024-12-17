import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class EditCategoryScreen extends StatefulWidget {
  final String categoryId; // Unique ID of the category in the database
  final String initialCategoryName; // Current name of the category
  final String initialImageUrl; // Current image URL of the category

  const EditCategoryScreen({
    super.key,
    required this.categoryId,
    required this.initialCategoryName,
    required this.initialImageUrl,
  });

  @override
  _EditCategoryScreenState createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  late TextEditingController _categoryController;

  // ImgBB API Key
  final String imgbbApiKey = "d681de430ca3e38e4fd9b87a08a91f96";

  // Realtime Database reference
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();

  // Image-related variables
  File? _imageFile; // For mobile/desktop
  Uint8List? _webImage; // For web
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _categoryController = TextEditingController(text: widget.initialCategoryName);
  }

  @override
  void dispose() {
    _categoryController.dispose();
    super.dispose();
  }

  // Function to pick an image
  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        if (kIsWeb) {
          final bytes = await pickedFile.readAsBytes();
          setState(() {
            _webImage = bytes;
            _imageFile = null; // Clear the file for web
          });
        } else {
          setState(() {
            _imageFile = File(pickedFile.path);
            _webImage = null; // Clear web image
          });
        }
      }
    } catch (e) {
      print("Error picking image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to pick image. Try again.")),
      );
    }
  }

  // Function to upload image to ImgBB
  Future<String?> _uploadImageToImgBB() async {
    final Uri uri = Uri.parse("https://api.imgbb.com/1/upload?key=$imgbbApiKey");

    try {
      final http.MultipartRequest request = http.MultipartRequest("POST", uri);

      if (kIsWeb && _webImage != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'image',
          _webImage!,
          filename: "image.jpg",
        ));
      } else if (_imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          _imageFile!.path,
        ));
      } else {
        return null; // No new image selected
      }

      final response = await request.send();
      final responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(responseData.body);
        return data["data"]["url"];
      } else {
        throw Exception("Failed to upload image.");
      }
    } catch (e) {
      print("Image upload error: $e");
      return null;
    }
  }

  // Function to update category in Firebase
  Future<void> _updateCategory() async {
    final String updatedName = _categoryController.text.trim();

    if (updatedName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a category name.")),
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      String? newImageUrl;

      // Upload image if a new image is selected
      if (_imageFile != null || _webImage != null) {
        newImageUrl = await _uploadImageToImgBB();
        if (newImageUrl == null) {
          throw Exception("Image upload failed.");
        }
      }

      // Update Firebase database
      await _databaseRef.child('categories').child(widget.categoryId).update({
        'name': updatedName,
        'imageUrl': newImageUrl ?? widget.initialImageUrl, // Use new or existing image URL
        'updatedAt': DateTime.now().toIso8601String(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Category updated successfully!")),
      );
      Navigator.pop(context);
    } catch (error) {
      print("Error updating category: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update category. Please try again.")),
      );
    } finally {
      setState(() => _isUploading = false);
    }
  }

  // Image picker widget
  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: _webImage != null
            ? Image.memory(_webImage!, fit: BoxFit.cover, errorBuilder: (_, __, ___) {
          return const Center(child: Text("Invalid Image"));
        })
            : _imageFile != null
            ? Image.file(_imageFile!, fit: BoxFit.cover, errorBuilder: (_, __, ___) {
          return const Center(child: Text("Invalid Image"));
        })
            : Image.network(widget.initialImageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) {
          return const Center(child: Icon(Icons.image_not_supported));
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Edit Category",
          style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(
                labelText: 'Category Name',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 20),
            _buildImagePicker(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isUploading ? null : _updateCategory,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: _isUploading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Update Category", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
