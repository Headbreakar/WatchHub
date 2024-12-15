import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class EditCategoryScreen extends StatefulWidget {
  final String categoryId; // The unique ID of the category in the database
  final String initialCategoryName; // The current name of the category

  const EditCategoryScreen({super.key, required this.categoryId, required this.initialCategoryName});

  @override
  _EditCategoryScreenState createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  late TextEditingController _categoryController;

  // Realtime Database reference
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();

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

  Future<void> _updateCategory(String updatedName) async {
    try {
      // Update the category in the database
      await _databaseRef.child('categories').child(widget.categoryId).update({'name': updatedName});

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Category updated successfully!")),
      );

      // Navigate back
      Navigator.pop(context);
    } catch (error) {
      // Handle errors
      print("Error updating category: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update category")),
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
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
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
            // Category Name Input Field
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(
                labelText: 'Category Name',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 20),

            // Save Button
            ElevatedButton(
              onPressed: () {
                String updatedCategoryName = _categoryController.text.trim();
                if (updatedCategoryName.isNotEmpty) {
                  _updateCategory(updatedCategoryName); // Update the category in the database
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter a category name")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text("Save", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
