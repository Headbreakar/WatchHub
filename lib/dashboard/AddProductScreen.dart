import 'dart:io';
import 'dart:typed_data'; // For Flutter Web
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  // ImgBB API Key (Replace with your actual API key)
  final String imgbbApiKey = "d681de430ca3e38e4fd9b87a08a91f96";

  // Controllers for text fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController shortDescriptionController = TextEditingController();
  final TextEditingController longDescriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  File? _imageFile; // For mobile/desktop
  Uint8List? _webImage; // For Flutter Web
  final ImagePicker _picker = ImagePicker(); // Image Picker to select an image

  // Firebase Realtime Database reference for categories and products
  final DatabaseReference _categoriesRef = FirebaseDatabase.instance.ref().child('categories');
  final DatabaseReference _productsRef = FirebaseDatabase.instance.ref().child('products');

  String? _selectedCategory; // Selected category ID
  List<Map<String, String>> _categories = []; // List to hold fetched categories

  @override
  void initState() {
    super.initState();
    _fetchCategories(); // Fetch categories from the database on screen load
  }

  Future<void> _fetchCategories() async {
    _categoriesRef.once().then((DatabaseEvent event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        final List<Map<String, String>> fetchedCategories = data.entries.map((entry) {
          return {
            "id": entry.key.toString(),
            "name": (entry.value as Map)['name'].toString(),
          };
        }).toList();
        setState(() {
          _categories = fetchedCategories;
        });
      }
    });
  }

  // Function to pick an image
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
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
          _imageFile = File(pickedFile.path);
        });
      }
    }
  }

  // Function to upload image to ImgBB
  Future<String> _uploadImage() async {
    final Uri uri = Uri.parse("https://api.imgbb.com/1/upload?key=$imgbbApiKey");

    try {
      http.MultipartRequest request = http.MultipartRequest("POST", uri);

      if (kIsWeb) {
        // For web, send the image bytes
        request.files.add(http.MultipartFile.fromBytes(
          'image',
          _webImage!,
          filename: "image.jpg",
        ));
      } else {
        // For mobile/desktop, send the image file
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          _imageFile!.path,
        ));
      }

      // Send the request
      final response = await request.send();
      final responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        final data = json.decode(responseData.body);
        final String imageUrl = data["data"]["url"];
        print("Image uploaded to ImgBB: $imageUrl");
        return imageUrl;
      } else {
        throw Exception("Failed to upload image to ImgBB. Status code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error uploading image to ImgBB: $error");
      throw error;
    }
  }

  // Function to add product to Realtime Database
  Future<void> _addProduct() async {
    String name = nameController.text.trim();
    String shortDesc = shortDescriptionController.text.trim();
    String longDesc = longDescriptionController.text.trim();
    String price = priceController.text.trim();

    if (name.isEmpty ||
        shortDesc.isEmpty ||
        longDesc.isEmpty ||
        price.isEmpty ||
        (_imageFile == null && _webImage == null) ||
        _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("All fields are required, including an image and category")),
      );
      return;
    }

    try {
      print("Uploading image...");
      String imageUrl = await _uploadImage();
      print("Image uploaded successfully: $imageUrl");

      print("Saving product to Realtime Database...");
      await _productsRef.push().set({
        'name': name,
        'shortDescription': shortDesc,
        'longDescription': longDesc,
        'price': price,
        'imageUrl': imageUrl,
        'categoryId': _selectedCategory,
      });
      print("Product saved successfully!");

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product added successfully!")));

      // Clear inputs and navigate back
      nameController.clear();
      shortDescriptionController.clear();
      longDescriptionController.clear();
      priceController.clear();
      setState(() {
        _imageFile = null;
        _webImage = null;
        _selectedCategory = null;
      });
      Navigator.pop(context);
    } catch (error) {
      print("Error adding product: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add product: $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Add Product",
          style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: shortDescriptionController,
                decoration: InputDecoration(
                  labelText: 'Short Description',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: longDescriptionController,
                decoration: InputDecoration(
                  labelText: 'Long Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
              SizedBox(height: 16),
              TextField(
                controller: priceController,
                decoration: InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                value: _selectedCategory,
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category['id'],
                    child: Text(category['name']!),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  kIsWeb
                      ? (_webImage != null
                      ? Image.memory(_webImage!, width: 100, height: 100, fit: BoxFit.cover)
                      : Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[300],
                    child: Icon(Icons.image, size: 50),
                  ))
                      : (_imageFile != null
                      ? Image.file(_imageFile!, width: 100, height: 100, fit: BoxFit.cover)
                      : Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[300],
                    child: Icon(Icons.image, size: 50),
                  )),
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text("Pick Image"),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addProduct,
                child: Text("Add Product"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
