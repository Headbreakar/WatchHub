import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddCategoryScreen extends StatefulWidget {
  @override
  _AddCategoryScreenState createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  // TextEditingController to handle input for category name
  final TextEditingController _categoryController = TextEditingController();

  // Realtime Database reference
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();

  @override
  void dispose() {
    _categoryController.dispose(); // Dispose the controller when the screen is removed
    super.dispose();
  }

  // Function to add a category to Realtime Database
  Future<void> _addCategory() async {
    String categoryName = _categoryController.text;

    if (categoryName.isNotEmpty) {
      try {
        // Add category to Realtime Database
        await _databaseRef.child('categories').push().set({
          'name': categoryName,
          'createdAt': DateTime.now().toIso8601String(), // Add timestamp for when the category was created
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Category Added Successfully")),
        );

        // Clear the input field and go back to the previous screen
        _categoryController.clear();
        Navigator.pop(context);
      } catch (e) {
        // Handle errors
        print("Error adding category: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to add category")),
        );
      }
    } else {
      // If the category name is empty, show a validation message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a category name")),
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
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
        title: Text(
          "Add Category",
          style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Category Name Input Field
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(
                labelText: 'Category Name',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            SizedBox(height: 20),

            // Save Button to Add Category
            ElevatedButton(
              onPressed: _addCategory,
              child: Text("Add Category", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
