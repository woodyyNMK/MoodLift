import 'package:flutter/material.dart';
import './authentication/signUpPage.dart';
import './authentication/logInPage.dart';
import './diary/diarypage.dart';
import './diary/diarydetailpage.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:auth_state_manager/auth_state_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await AuthStateManager.initializeAuthState();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final storage = const FlutterSecureStorage(); 
  
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Sign Up Page',
      home: Scaffold(
        body: LogInPage(),
      ),
    );
    
  }
}
