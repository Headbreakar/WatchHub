import 'package:flutter/material.dart';
class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
    backgroundColor: Colors.green,
     title: Text('Login Page'),),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Email'
              ),
            ),
            TextField(
              decoration: InputDecoration(
                  labelText: 'Password'
              ),
            ),
            ElevatedButton(onPressed: (){
              print("Logged In successfully");
            }, child: Text("Login"))
          ],
        ),
        ),
      ),
    );
  }
}
