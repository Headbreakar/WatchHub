import 'package:flutter/material.dart';
import 'package:flutterofflie/main.dart';
import 'package:flutterofflie/login.dart';
import 'package:flutterofflie/register.dart';
class splash extends StatefulWidget {
  const splash({super.key});

  @override
  State<splash> createState() => _splashState();
}

class _splashState extends State<splash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hello Flutter Developer"),
        backgroundColor: Colors.green,
      ),
      body: Center(
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         crossAxisAlignment: CrossAxisAlignment.center,
         children: [
           Text('Welcome to our application', style: TextStyle(fontSize: 25.0),),
           SizedBox(height: 10.0,),
           Image.asset('car.jpg' ,width: 300.0),
           SizedBox(height: 10.0,),
           Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               ElevatedButton(
                 onPressed: () {
                   Navigator.push(
                     context,
                     MaterialPageRoute(builder: (context) => login()),
                   );
                 },
                 child: Text('Login')),
               ElevatedButton(
                   onPressed: () {
                     Navigator.push(
                       context,
                       MaterialPageRoute(builder: (context) => register()),
                     );
                   },
                   child: Text('Register')),
             ]
           )
        ],
       ),
      ),
    );
  }
}
