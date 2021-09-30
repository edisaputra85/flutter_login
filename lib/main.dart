import 'package:flutter/material.dart';
import './register.dart';
import './login.dart';
import './dashboard.dart';
import './editprofile.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/register',
      routes: {
        '/login': (context) => Login(),
        '/register': (context) => Register(),
        '/dashboard': (context) => Dashboard(),
        '/editprofile': (context) => EditProfile(),
      },
    );
  }
}
