import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutterofflie/dashboard/DashboardScreen.dart';
import 'package:flutterofflie/dashboard/ProductsScreen.dart';
import 'package:image_picker/image_picker.dart';

class EditProductScreen extends StatefulWidget {
  final String productId;

  // You can pass product details to the Edit screen through the constructor
  EditProductScreen({required this.productId});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  // Controllers for text fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController shortDescriptionController = TextEditingController();
  final TextEditingController longDescriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  File? _imageFile; // Variable to hold the image file

  // Image Picker to select an image
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Fetch product details using the productId, and set initial values for the fields
    _fetchProductDetails();
  }

  // Dummy function to simulate fetching the product details
  void _fetchProductDetails() {
    // Here, you would fetch data from your database or API.
    // For now, let's assume we're populating the fields with existing data.
    setState(() {
      nameController.text = 'Existing Product Name';
      shortDescriptionController.text = 'Short description of the product.';
      longDescriptionController.text = 'This is a long description of the product.';
      priceController.text = '199.99';
      // If an image URL or file path is provided, you can load that here as well
      // _imageFile = File('path_to_existing_image');
    });
  }

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
        leading: BackButton(color: Colors.black), // Replaces the drawer icon with back button
        title: Text(
          "Edit Product",
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
                  // Simulate updating the product by printing the entered data
                  String name = nameController.text;
                  String shortDesc = shortDescriptionController.text;
                  String longDesc = longDescriptionController.text;
                  String price = priceController.text;

                  if (name.isEmpty || shortDesc.isEmpty || longDesc.isEmpty || price.isEmpty || _imageFile == null) {
                    // Handle empty fields if needed
                    print("All fields are required.");
                    return;
                  }

                  print("Product Updated:");
                  print("Name: $name");
                  print("Short Description: $shortDesc");
                  print("Long Description: $longDesc");
                  print("Price: $price");
                  print("Image: ${_imageFile!.path}");

                  // After updating the product, navigate back to the products list screen
                  // You may want to save the product data in a database or API here
                },
                child: Text("Save Changes", style: TextStyle(color: Colors.white)),
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
