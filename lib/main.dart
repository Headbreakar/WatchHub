import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterofflie/LoginScreen.dart';
import 'package:flutterofflie/SignUpScreen.dart';
import 'package:flutterofflie/WatchEaseScreen.dart';
// Your CategoriesScreen
import 'firebase_options.dart'; // Import the generated file

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures Flutter binding is initialized

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform, // Pass the options
    );
    print("Firebase Initialized Successfully");
  } catch (e) {
    print("Error initializing Firebase: $e"); // Log the error
  }

  runApp(const WatchEaseApp());
}

class WatchEaseApp extends StatelessWidget {
  const WatchEaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const WatchEaseScreen(),
      theme: ThemeData(
        fontFamily: 'Nunito',
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
