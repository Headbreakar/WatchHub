import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  _AddCategoryScreenState createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  // ImgBB API Key (Replace with your own key)
  final String imgbbApiKey = "d681de430ca3e38e4fd9b87a08a91f96";

  // Realtime Database reference
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();

  // Controllers
  final TextEditingController _categoryController = TextEditingController();

  // Image-related variables
  File? _imageFile; // For mobile/desktop
  Uint8List? _webImage; // For web
  final ImagePicker _picker = ImagePicker();

  bool _isUploading = false;

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
          });
        } else {
          setState(() {
            _imageFile = File(pickedFile.path);
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
        throw Exception("No image selected");
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

  // Function to add category
  Future<void> _addCategory() async {
    final String categoryName = _categoryController.text.trim();

    if (categoryName.isEmpty || (_imageFile == null && _webImage == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a category name and select an image.")),
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      final String? imageUrl = await _uploadImageToImgBB();

      if (imageUrl != null) {
        await _databaseRef.child('categories').push().set({
          'name': categoryName,
          'imageUrl': imageUrl,
          'createdAt': DateTime.now().toIso8601String(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Category added successfully!")),
        );

        _categoryController.clear();
        setState(() {
          _imageFile = null;
          _webImage = null;
        });

        Navigator.pop(context);
      } else {
        throw Exception("Failed to upload image.");
      }
    } catch (e) {
      print("Error adding category: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _isUploading = false);
    }
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
          "Add Category",
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
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _webImage != null
                    ? Image.memory(_webImage!, fit: BoxFit.cover)
                    : _imageFile != null
                    ? Image.file(_imageFile!, fit: BoxFit.cover)
                    : const Center(
                  child: Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isUploading ? null : _addCategory,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: _isUploading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Add Category", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
