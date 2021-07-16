import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pareezblling/screens/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      theme: ThemeData(
        cursorColor: Colors.white,
      ),
    );
  }
}
