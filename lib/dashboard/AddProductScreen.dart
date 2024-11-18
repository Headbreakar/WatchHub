import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutterofflie/dashboard/DashboardScreen.dart';
import 'package:flutterofflie/dashboard/ProductsScreen.dart';
import 'package:image_picker/image_picker.dart'; // Image Picker package for picking images

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  // Controllers for text fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController shortDescriptionController = TextEditingController();
  final TextEditingController longDescriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  File? _imageFile; // Variable to hold the image file

  // Image Picker to select an image
  final ImagePicker _picker = ImagePicker();

  // Function to pick an image
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
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
            Navigator.pop(context); // Navigates back to the previous screen
          },
        ),
        title: Text(
          "Add Product",
          style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          CircleAvatar(
            backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Name Field
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Product Name',
                  hintText: 'Enter product name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              // Short Description Field
              TextField(
                controller: shortDescriptionController,
                decoration: InputDecoration(
                  labelText: 'Short Description',
                  hintText: 'Enter short description',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              // Long Description Field
              TextField(
                controller: longDescriptionController,
                decoration: InputDecoration(
                  labelText: 'Long Description',
                  hintText: 'Enter detailed product description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
              SizedBox(height: 16),

              // Price Field
              TextField(
                controller: priceController,
                decoration: InputDecoration(
                  labelText: 'Price',
                  hintText: 'Enter product price',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),

              // Image Picker (Pick Image from Gallery)
              Row(
                children: [
                  _imageFile == null
                      ? Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[300],
                    child: Icon(Icons.image, size: 50, color: Colors.white),
                  )
                      : Image.file(
                    _imageFile!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text('Pick Image'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      textStyle: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Save Product Button
              ElevatedButton(
                onPressed: () {
                  // Simulate adding the product by printing the entered data
                  String name = nameController.text;
                  String shortDesc = shortDescriptionController.text;
                  String longDesc = longDescriptionController.text;
                  String price = priceController.text;

                  if (name.isEmpty || shortDesc.isEmpty || longDesc.isEmpty || price.isEmpty || _imageFile == null) {
                    // Handle empty fields if needed
                    print("All fields are required.");
                    return;
                  }

                  print("Product Added:");
                  print("Name: $name");
                  print("Short Description: $shortDesc");
                  print("Long Description: $longDesc");
                  print("Price: $price");
                  print("Image: ${_imageFile!.path}");

                  // After adding the product, navigate back to the products list screen
                  // You may want to save the product data in a database or API here
                  Navigator.pop(context); // Navigate back to the previous screen (or to the products list screen)
                },
                child: Text("Add", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
