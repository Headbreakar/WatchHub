import 'package:flutter/material.dart';
import 'package:flutterofflie/SignUpScreen.dart';
import 'package:flutterofflie/WatchEaseScreen.dart';
import 'package:flutterofflie/dashboard/DashboardScreen.dart';

void main() {
  runApp(WatchEaseApp());
}

class WatchEaseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DashboardScreen(),
      theme: ThemeData(
        fontFamily: 'Nunito',
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}


