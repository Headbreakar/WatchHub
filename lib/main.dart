import 'package:flutter/material.dart';
import 'package:flutterofflie/SignUpScreen.dart';
import 'package:flutterofflie/Store/CheckoutPage.dart';
import 'package:flutterofflie/Store/singleCategory.dart';
import 'package:flutterofflie/WatchEaseScreen.dart';
import 'package:flutterofflie/dashboard/AddProductScreen.dart';
import 'package:flutterofflie/dashboard/CategoriesScreen.dart';
import 'package:flutterofflie/dashboard/DashboardScreen.dart';
import 'package:flutterofflie/createProfile.dart';
import 'package:flutterofflie/LoginScreen.dart';
import 'package:flutterofflie/Store/homepage.dart';
import 'package:flutterofflie/Store/category.dart';
import 'package:flutterofflie/Store/CartPage.dart';
import 'package:flutterofflie/Store/Product.dart';
import 'package:flutterofflie/Store/UserProfile.dart';
import 'package:flutterofflie/dashboard/EditOrderScreen.dart';
import 'package:flutterofflie/dashboard/EditProductScreen.dart';

void main() {
  runApp(WatchEaseApp());
}

class WatchEaseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CategoriesScreen(),
      theme: ThemeData(
        fontFamily: 'Nunito',
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}


