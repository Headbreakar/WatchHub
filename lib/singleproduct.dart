import 'package:flutter/material.dart';
class product extends StatefulWidget {
  const product({super.key});

  @override
  State<product> createState() => _productState();
}

class _productState extends State<product> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,



            ),
          ],
        ),
      ),
    );
  }
}
