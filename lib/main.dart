import 'package:flutter/material.dart';
import 'package:mood_lift/model/liquidmodel.dart';
import './authentication/signUpPage.dart';
import './authentication/logInPage.dart';
import './diary/diarypage.dart';
import './diary/diaryviewpage.dart';
import 'diary/librarypage.dart';
import './diary/moodsummary.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:auth_state_manager/auth_state_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await AuthStateManager.initializeAuthState();
  runApp(const MyApp());
}

class StorageUtil {
  static final StorageUtil _instance = StorageUtil._();
  final FlutterSecureStorage _storage;

  StorageUtil._() : _storage = const FlutterSecureStorage();

  static FlutterSecureStorage get storage => _instance._storage;
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final storage = const FlutterSecureStorage();

  Future<String?> getToken() async {
    return await storage.read(key: 'idToken');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mood Lift',
      home: FutureBuilder<String?>(
        future: getToken(),
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Show a loading spinner while waiting
          } else {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return Scaffold(body : DiaryPage()); // If the token exists, redirect to DiaryPage
            } else {
              return Scaffold(body : LogInPage()); // If the token doesn't exist, redirect to LogInPage
            }
          }
        },
      ),
    );
  }
}
