import 'package:flutter/material.dart';
class register extends StatefulWidget {
  const register({super.key});

  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Register Page'),),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                    labelText: 'First Name'
                ),
              ),
              TextField(
                decoration: InputDecoration(
                    labelText: 'Last Name'
                ),
              ),
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
                print("Registered successfully");
              }, child: Text("Register"))            ],
          ),
        ),
      ),
    );
  }
}
