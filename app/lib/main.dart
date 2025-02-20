import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Лабораторні роботи',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        hintColor: Colors.orangeAccent,
      ),
      home: HomeScreen(),
    );
  }
}
