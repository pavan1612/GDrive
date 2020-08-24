import 'package:GDrive_connect/screens/authpage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'GDrive Connect',
        theme: ThemeData(
          primarySwatch: Colors.lightGreen,
          accentColor: Color.fromRGBO(214, 255, 191, 20),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: AuthPage());
  }
}
