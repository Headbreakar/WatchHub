import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterofflie/Store/homepage.dart';
import 'package:flutterofflie/WatchEaseScreen.dart';
import 'package:flutterofflie/dashboard/CategoriesScreen.dart'; // Your CategoriesScreen
import 'package:flutterofflie/dashboard/DashboardScreen.dart';
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

  runApp(WatchEaseApp());
}

class WatchEaseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      theme: ThemeData(
        fontFamily: 'Nunito',
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
