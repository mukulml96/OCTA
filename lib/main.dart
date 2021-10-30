import 'package:flutter/material.dart';

import 'config.dart';
import 'home.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OCTA',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(Config.APP_URL),
      debugShowCheckedModeBanner: false,
    );
  }
}
