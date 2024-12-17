import 'package:flutter/material.dart';

class PolicyPage extends StatelessWidget {
  const PolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Navigate back to previous page
          },
        ),
        title: const Text(
          "Privacy Policy",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.black,  // Set background color to black
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Section
              const Text(
                'Privacy Policy',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Introductory Text
              const Text(
                'Your privacy is important to us. This privacy policy outlines how we collect, use, and protect your personal data...',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 30),

              // Privacy Policy Sections
              _buildPolicySection('1. Information Collection',
                  'We collect personal data when you use our services, such as your name, email address, phone number, and other personal identifiers. This information is collected when you sign up for an account or interact with our app.'
              ),
              _buildPolicySection('2. Use of Information',
                  'The personal data we collect will be used to provide, personalize, and improve your experience with our services. We may use this data to communicate with you, provide updates, and send notifications about our services.'
              ),
              _buildPolicySection('3. Data Security',
                  'We take data security seriously and implement various measures to protect your personal data. This includes encryption of sensitive data and using secure communication channels.'
              ),
              _buildPolicySection('4. Data Sharing',
                  'We do not sell, rent, or trade your personal data to third parties. We may share your information with trusted service providers who assist in delivering our services. These third parties are obligated to protect your information.'
              ),
              _buildPolicySection('5. Your Rights',
                  'You have the right to access, update, or delete your personal data. You can request a copy of the data we have about you, and you can ask us to correct any inaccuracies.'
              ),
              _buildPolicySection('6. Cookies',
                  'We use cookies to improve your experience with our app. Cookies help us remember your preferences, personalize content, and analyze how our services are being used.'
              ),
              _buildPolicySection('7. Changes to the Privacy Policy',
                  'We may update our privacy policy from time to time. Any changes will be posted on this page, and the "last updated" date will be revised. We encourage you to review this policy periodically.'
              ),
              _buildPolicySection('8. Contact Us',
                  'If you have any questions about this privacy policy or our data practices, please contact us at support@example.com.'
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to create policy sections in a card-like format
  Widget _buildPolicySection(String title, String content) {
    return Card(
      color: Colors.black,
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              content,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
