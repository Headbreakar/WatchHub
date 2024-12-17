import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController _feedbackController = TextEditingController();
  String _selectedType = "Bug";
  int _rating = 0;
  bool _isSubmitting = false;

  final List<String> _feedbackTypes = ["Bug", "Suggestion", "Complaint"];


  Future<void> _submitFeedback() async {
    if (_feedbackController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your feedback!")),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // Get current user ID
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw "User not logged in";

      // Prepare feedback data
      final feedbackData = {
        "userId": user.uid,
        "type": _selectedType,
        "feedback": _feedbackController.text,
        "rating": _rating,
        "timestamp": DateTime.now().toIso8601String(),
      };

      // Insert feedback into Realtime Database
      DatabaseReference ref = FirebaseDatabase.instance.ref("feedbacks").push();
      await ref.set(feedbackData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Feedback submitted successfully!")),
      );

      // Clear the form
      _feedbackController.clear();
      setState(() {
        _selectedType = "Bug";
        _rating = 0;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Feedback",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text(
              "We value your feedback!",
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Feedback Type Dropdown
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1E),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: DropdownButton<String>(
                value: _selectedType,
                dropdownColor: const Color(0xFF1C1C1E),
                isExpanded: true,
                underline: const SizedBox(),
                style: const TextStyle(color: Colors.white),
                onChanged: (value) => setState(() => _selectedType = value!),
                items: _feedbackTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // Feedback Text Field
            TextField(
              controller: _feedbackController,
              maxLines: 5,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Share your thoughts...",
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF1C1C1E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Star Rating
            const Text("Rate Us", style: TextStyle(color: Colors.white, fontSize: 16)),
            Row(
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () => setState(() => _rating = index + 1),
                  icon: Icon(
                    Icons.star,
                    color: index < _rating ? Colors.yellow : Colors.grey,
                    size: 30,
                  ),
                );
              }),
            ),
            const SizedBox(height: 30),

            // Submit Button
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: _isSubmitting ? null : _submitFeedback,
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Submit Feedback", style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
