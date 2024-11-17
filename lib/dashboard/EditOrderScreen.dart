import 'package:flutter/material.dart';

class EditOrderScreen extends StatefulWidget {
  final Map<String, dynamic> order;

  EditOrderScreen({required this.order});

  @override
  _EditOrderScreenState createState() => _EditOrderScreenState();
}

class _EditOrderScreenState extends State<EditOrderScreen> {
  late TextEditingController customerNameController;
  late TextEditingController totalPriceController;
  late TextEditingController addressController;
  late TextEditingController contactNumberController;
  late TextEditingController emailController;
  late TextEditingController notesController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with the order data
    customerNameController = TextEditingController(text: widget.order['customerName']);
    totalPriceController = TextEditingController(text: widget.order['totalPrice']);
    addressController = TextEditingController(text: widget.order['address']);
    contactNumberController = TextEditingController(text: widget.order['contactNumber']);
    emailController = TextEditingController(text: widget.order['email']);
    notesController = TextEditingController(text: widget.order['notes']);
  }

  @override
  void dispose() {
    // Dispose of controllers when the screen is closed
    customerNameController.dispose();
    totalPriceController.dispose();
    addressController.dispose();
    contactNumberController.dispose();
    emailController.dispose();
    notesController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    // Simulate saving the updated order
    final updatedOrder = {
      'customerName': customerNameController.text,
      'totalPrice': totalPriceController.text,
      'address': addressController.text,
      'contactNumber': contactNumberController.text,
      'email': emailController.text,
      'notes': notesController.text,
    };

    print("Order updated: $updatedOrder");

    // Close the screen after saving
    Navigator.pop(context, updatedOrder);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Edit Order",
          style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField("Customer Name", customerNameController),
              SizedBox(height: 16),
              _buildTextField("Total Price", totalPriceController, isNumber: true),
              SizedBox(height: 16),
              _buildTextField("Address", addressController),
              SizedBox(height: 16),
              _buildTextField("Contact Number", contactNumberController),
              SizedBox(height: 16),
              _buildTextField("Email", emailController),
              SizedBox(height: 16),
              _buildTextField("Notes", notesController, maxLines: 3),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveChanges,
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

  Widget _buildTextField(String label, TextEditingController controller, {bool isNumber = false, int maxLines = 1}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }
}
