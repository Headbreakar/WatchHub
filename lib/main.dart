import 'package:flutter/material.dart';
import 'package:flutterofflie/SignUpScreen.dart';
import 'package:flutterofflie/Store/singleCategory.dart';
import 'package:flutterofflie/WatchEaseScreen.dart';
import 'package:flutterofflie/dashboard/DashboardScreen.dart';
import 'package:flutterofflie/createProfile.dart';
import 'package:flutterofflie/LoginScreen.dart';
import 'package:flutterofflie/Store/homepage.dart';
import 'package:flutterofflie/Store/category.dart';
import 'package:flutterofflie/Store/CartPage.dart';
import 'package:flutterofflie/Store/Product.dart';

void main() {
  runApp(WatchEaseApp());
}

class WatchEaseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: ProductPage(),

      theme: ThemeData(
        fontFamily: 'Nunito',
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}


