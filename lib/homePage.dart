import 'package:flutterofflie/SignUpScreen.dart';
import 'package:flutterofflie/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutterofflie/WatchEaseScreen.dart';

class homePage extends StatefulWidget {
const homePage({super.key});

@override
State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
@override
Widget build(BuildContext context) {
return Scaffold(

appBar: AppBar(title: Text("Wellcome to Our App !!!"),
backgroundColor: Colors.green,
centerTitle: true,
),
drawer: const sidebar(),
body: Row(
children: [

],
),
);
}
}


class sidebar extends StatefulWidget {
const sidebar({super.key});

@override
State<sidebar> createState() => _sidebarState();
}

class _sidebarState extends State<sidebar> {
@override
Widget build(BuildContext context) {
return Drawer(
child : ListView(
children: <Widget> [
DrawerHeader(
child: Text('Example App'),
decoration: BoxDecoration(color: Colors.white),
// child: Text('In publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content. '),
),

ListTile(
leading: Icon(Icons.home),
title: Text("Home"),
onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => LoginScreen()),
  );
},
),
ListTile(
leading: Icon(Icons.login),
title: Text("login"),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  },
),    ListTile(
leading: Icon(Icons.app_registration),
title: Text("register"),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignUpScreen()),
      );
    },
),
  ListTile(
leading: Icon(Icons.home_max_sharp),
title: Text("splash"),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WatchEaseScreen()),
      );
    },
),

],
)
);
}
}
