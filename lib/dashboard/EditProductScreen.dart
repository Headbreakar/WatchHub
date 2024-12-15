import 'dart:io';
// For Flutter Web
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'ProductsScreen.dart';

class EditProductScreen extends StatefulWidget {
  final String productId;

  const EditProductScreen({super.key, required this.productId});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final String imgbbApiKey = "d681de430ca3e38e4fd9b87a08a91f96";

  // Controllers for text fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController shortDescriptionController = TextEditingController();
  final TextEditingController longDescriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  File? _imageFile; // For mobile/desktop
  Uint8List? _webImage; // For Flutter Web
  final ImagePicker _picker = ImagePicker(); // Image Picker to select an image

  bool _isLoading = false;
  bool _isFetchingData = false; // Flag for fetch loading

  String? _imageUrl; // Variable to store the image URL fetched from Firebase

  // Firebase Realtime Database reference for products
  final DatabaseReference _productsRef = FirebaseDatabase.instance.ref().child('products');

  @override
  void initState() {
    super.initState();
    _fetchProductDetails();  // Fetch product details when the screen loads
  }

  // Fetch product details from Firebase
  Future<void> _fetchProductDetails() async {
    setState(() {
      _isFetchingData = true;
    });

    try {
      final DatabaseEvent event = await _productsRef.child(widget.productId).once();
      final data = event.snapshot.value as Map?;

      if (data != null) {
        setState(() {
          nameController.text = data['name'].toString();
          shortDescriptionController.text = data['shortDescription'].toString();
          longDescriptionController.text = data['longDescription'].toString();
          priceController.text = data['price'].toString();
          _imageUrl = data['imageUrl']; // Store the image URL from Firebase
        });
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error fetching product data")));
    } finally {
      setState(() {
        _isFetchingData = false;
      });
    }
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
        request.files.add(http.MultipartFile.fromBytes(
          'image',
          _webImage!,
          filename: "image.jpg",
        ));
      } else {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          _imageFile!.path,
        ));
      }

      final response = await request.send();
      final responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        final data = json.decode(responseData.body);
        final String imageUrl = data["data"]["url"];
        return imageUrl;
      } else {
        throw Exception("Failed to upload image");
      }
    } catch (error) {
      rethrow;
    }
  }

  // Function to update the product details in Firebase
  // Function to update the product details in Firebase
  Future<void> _updateProduct() async {
    String name = nameController.text.trim();
    String shortDesc = shortDescriptionController.text.trim();
    String longDesc = longDescriptionController.text.trim();
    String price = priceController.text.trim();

    if (name.isEmpty || shortDesc.isEmpty || longDesc.isEmpty || price.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("All fields are required")));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // If no new image is selected, use the existing image URL
      String imageUrl = (_imageFile != null || _webImage != null)
          ? await _uploadImage()  // Upload new image if selected
          : _imageUrl ?? '';  // If no new image, retain the existing URL

      // Update the product data in Firebase
      await _productsRef.child(widget.productId).update({
        'name': name,
        'shortDescription': shortDesc,
        'longDescription': longDesc,
        'price': price,
        'imageUrl': imageUrl.isNotEmpty ? imageUrl : '', // Use existing image URL if no new image
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Product updated successfully!")));
      Navigator.pop(context); // Go back to the previous screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProductsScreen()), // Push ProductsScreen again
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to update product: $error")));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          "Edit Product",
          style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isFetchingData
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  hintText: 'Enter product name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: shortDescriptionController,
                decoration: const InputDecoration(
                  labelText: 'Short Description',
                  hintText: 'Enter short description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: longDescriptionController,
                decoration: const InputDecoration(
                  labelText: 'Long Description',
                  hintText: 'Enter detailed description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  hintText: 'Enter price',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _imageFile == null && _webImage == null
                      ? _imageUrl != null
                      ? Image.network(_imageUrl!, width: 100, height: 100, fit: BoxFit.cover)
                      : Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image, size: 50),
                  )
                      : (_webImage != null
                      ? Image.memory(_webImage!, width: 100, height: 100, fit: BoxFit.cover)
                      : Image.file(_imageFile!, width: 100, height: 100, fit: BoxFit.cover)),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text("Pick Image"),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateProduct,
                child: const Text("Save Changes"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
