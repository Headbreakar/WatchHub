import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpdateFieldScreen extends StatefulWidget {
  final String field; // Field to update (e.g., "Phone", "Address")
  final String value; // Current value of the field
  final VoidCallback onFieldUpdated;

  const UpdateFieldScreen({super.key, required this.field, required this.value, required this.onFieldUpdated});

  @override
  _UpdateFieldScreenState createState() => _UpdateFieldScreenState();
}

class _UpdateFieldScreenState extends State<UpdateFieldScreen> {
  final TextEditingController _controller = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.value; // Set the initial value in the text field
  }

  Future<void> _updateField() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) return;

    if (_controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Field cannot be empty')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        widget.field.toLowerCase(): _controller.text, // Update the field
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${widget.field} updated successfully')),
      );

      // Call the callback to trigger a refresh in the parent widget
      widget.onFieldUpdated();

      // Navigate back to the Profile screen
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update field. Please try again.')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Navigate back to HomePage
          },
        ),
        title: Text(
          'Update ${widget.field}',
          style: const TextStyle(color: Colors.white),
        ),

        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Update your ${widget.field}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF1A1A1A),
                hintText: 'Enter new ${widget.field}',
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _updateField,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3A4F7A),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                  'Update ${widget.field}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
