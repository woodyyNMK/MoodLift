// import 'package:flutter/material.dart';
// import 'package:mood_lift/model/liquidmodel.dart';
// import './authentication/signUpPage.dart';
// import './authentication/logInPage.dart';
// import './diary/diarypage.dart';
// import './diary/diaryviewpage.dart';
// import 'diary/librarypage.dart';
// import './diary/moodsummary.dart';

// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:auth_state_manager/auth_state_manager.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Future<void> main() async {
//   await dotenv.load(fileName: ".env");
//   WidgetsFlutterBinding.ensureInitialized();
//   await AuthStateManager.initializeAuthState();
//   runApp(const MyApp());
// }

// class StorageUtil {
//   static final StorageUtil _instance = StorageUtil._();
//   final FlutterSecureStorage _storage;

//   StorageUtil._() : _storage = const FlutterSecureStorage();

//   static FlutterSecureStorage get storage => _instance._storage;
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   final storage = const FlutterSecureStorage();

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       title: 'Sign Up Page',
//       home: Scaffold(
//         body: DiaryPage(),
//       ),
//     );
//   }
// }
import '../model/colormodel.dart';
import '../model/musicmodel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SentimentAnalyzer(),
    );
  }
}

class SentimentAnalyzer extends StatefulWidget {
  const SentimentAnalyzer({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SentimentAnalyzerState createState() => _SentimentAnalyzerState();
}

class _SentimentAnalyzerState extends State<SentimentAnalyzer> {
  final TextEditingController _controller = TextEditingController();
  String _result = "";
  int _displayHighestScore = 0;

  LinearGradient _backgroundGradient =
      BackgroundColors.getSentimentColor('Neutral');

  void _analyzeSentiment(String text) async {
    final response = await http.post(
      Uri.parse(
          'https://api-inference.huggingface.co/models/cardiffnlp/twitter-roberta-base-sentiment'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer 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',
      },
      body: jsonEncode(<String, String>{'inputs': text}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final highestScore = (data[0][0]['score'] * 100).round();
      final totalScore =
          (data[0].fold(0, (sum, item) => sum + item['score']) * 100).round();
      final labelMapping = {
        'LABEL_0': 'Negative',
        'LABEL_1': 'Neutral',
        'LABEL_2': 'Positive',
      };
      final sentiment = labelMapping[data[0][0]['label']];

      setState(() {
        _result =
            "Mood: $sentiment, Highest Score: $highestScore%, Total Score: $totalScore%";
        _displayHighestScore = highestScore;

        _backgroundGradient = BackgroundColors.getSentimentColor(sentiment!);
      });
      SoundManager.playSound(sentiment!);
    } else {
      throw Exception('Failed to analyze sentiment');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sentiment Analyzer')),
      body: AnimatedContainer(
        duration: const Duration(seconds: 1),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(gradient: _backgroundGradient),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration: const InputDecoration(hintText: 'Enter text...'),
              onChanged: (text) {
                if (text.endsWith('.')) {
                  _analyzeSentiment(text);
                }
              },
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            Text(_result),
            Text('$_displayHighestScore'),
          ],
        ),
      ),
    );
  }
}
