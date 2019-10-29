import 'package:flutter/material.dart';


import 'package:io_nav/idLocationRoute.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  List<String> _platformVersion = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: idLocationRoute(),
    );
  }
}
