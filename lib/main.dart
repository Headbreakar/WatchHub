import 'package:flutter/material.dart';
import 'package:flutterofflie/SignUpScreen.dart';
import 'package:flutterofflie/WatchEaseScreen.dart';
import 'package:flutterofflie/dashboard/DashboardScreen.dart';
import 'package:flutterofflie/createProfile.dart';
import 'package:flutterofflie/LoginScreen.dart';

void main() {
  runApp(WatchEaseApp());
}

class WatchEaseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
      theme: ThemeData(
        fontFamily: 'Nunito',
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}


