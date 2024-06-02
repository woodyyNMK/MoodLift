import 'package:flutter/material.dart';
import './authentication/signUpPage.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Sign Up Page',
      home: Scaffold(
        body: SignUpPage(),
      ),
    );
  }
}
