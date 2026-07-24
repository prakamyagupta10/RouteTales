import 'package:flutter/material.dart';
import 'screens/home_page.dart';

void main() {
  runApp(const RouteTalesApp());
}

class RouteTalesApp extends StatelessWidget {
  const RouteTalesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "RouteTales",
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}