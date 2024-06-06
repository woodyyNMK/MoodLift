import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:mood_lift/main.dart';
import 'librarypage.dart';
import './moodsummary.dart';
import './articlepage.dart';
import '../model/colormodel.dart';
import '../model/musicmodel.dart';

import 'package:mood_lift/main.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  final scafflodkey = GlobalKey<ScaffoldState>();

  //-----------------Diary Controller function ----------------

  final _diarycontroller = TextEditingController();
  final String? url = dotenv.env['SERVER_URL'];

  //-----------------Create Diary in DB Function ----------------

  void _createDiary() async {
    final key = encrypt.Key.fromUtf8(dotenv.env['ENCRYPTION_KEY']!);
    final iv = encrypt.IV.fromUtf8(dotenv.env['ENCRYPTION_IV']!);
    final encrypter = encrypt.Encrypter(encrypt.AES(key,mode: AESMode.cbc));
    final encryptedDiary = encrypter.encrypt(_diarycontroller.text, iv:iv);
    
    String? token = await StorageUtil.storage.read(key: 'idToken');
    try {
      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      };
      var request = {
        "diary": encryptedDiary.base64,
        "iv": iv.base64,
        "positive": _displayHighestScore,
        "negative": 100 - _displayHighestScore,
      };
      final response = await http.post(Uri.parse("$url/createDiary"),
          headers: headers, body: json.encode(request));
      var responsePayload = json.decode(response.body);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responsePayload['message']),
            duration: const Duration(seconds: 2),
          ),
        );
        setState(() {
          _diarycontroller.clear();
        });
        setState(() {
          _diarycontroller.clear();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responsePayload['message']),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  //---------------NLP sentiment Analysis function----------------
  final String? nlptoken = dotenv.env['NLP_TOKEN'];

  String _result = "";
  int _displayHighestScore = 0;
  String _mood = "";

  LinearGradient _backgroundGradient =
      BackgroundColors.getSentimentColor('Neutral');
  void _analyzeSentiment(String text) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://api-inference.huggingface.co/models/cardiffnlp/twitter-roberta-base-sentiment'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $nlptoken',
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
        _mood = sentiment.toString();

        setState(() {
          _result =
              "Mood: $sentiment, Highest Score: $highestScore%, Total Score: $totalScore%";
          _displayHighestScore = highestScore;

          _backgroundGradient = BackgroundColors.getSentimentColor(sentiment!);
          print(sentiment);
          print(_result);
        });
        SoundManager.playSound(sentiment!);
      } else {
        throw Exception('Failed to analyze sentiment');
      }
    } catch (e) {
      print("FAILED TO ANALYZE SENTIMENT");
      throw Exception('Failed to analyze sentiment');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scafflodkey,
      body: AnimatedContainer(
        duration: const Duration(seconds: 1),
        width: double.infinity,
        decoration: BoxDecoration(gradient: _backgroundGradient),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 25, 0, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'How\'s Your Day, ',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.suwannaphum().fontFamily,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  Text(
                    'PETER ?',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.suwannaphum().fontFamily,
                      color: const Color.fromARGB(255, 21, 80, 194),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
                child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(25, 15, 25, 0),
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.sizeOf(context).height * 0.65,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(36),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 4,
                          color: Color(0x33000000),
                          offset: Offset(0, 0.0),
                          spreadRadius: 6,
                        )
                      ],
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              15, 15, 15, 0),
                          child: TextFormField(
                            controller: _diarycontroller,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Wrtite your thoughts here...",
                              hintStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                fontFamily: GoogleFonts.splineSans().fontFamily,
                                color: Colors.grey,
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: GoogleFonts.splineSans().fontFamily,
                              color: Colors.black,
                            ),
                            maxLines: 33,
                            onChanged: (_diarycontroller) {
                              if (_diarycontroller.endsWith('.')) {
                                _analyzeSentiment(_diarycontroller);
                              }
                            },
                          ),
                        ),
                        Stack(
                          alignment: const AlignmentDirectional(0, 1),
                          children: [
                            Align(
                              alignment: const AlignmentDirectional(0, 1.1),
                              child: FloatingActionButton(
                                backgroundColor: const Color(0xFFD9D9D9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(36),
                                ),
                                onPressed: _createDiary,
                                child: const FaIcon(
                                  FontAwesomeIcons.check,
                                  color: Color(0xFF000000),
                                  size: 25,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          _mood == ""
                              ? "0 %"
                              : _mood == "Neutral"
                                  ? "50 %"
                                  : _mood == "Positive"
                                      ? '${_displayHighestScore} %'
                                      : '${100 - _displayHighestScore} %',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: GoogleFonts.suwannaphum().fontFamily,
                            color: Colors.green,
                          ),
                        ),
                        Text(
                          'Positive Mood',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: GoogleFonts.suwannaphum().fontFamily,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          _mood == ""
                              ? "0 %"
                              : _mood == "Neutral"
                                  ? "50 %"
                                  : _mood == "Negative"
                                      ? '${_displayHighestScore} %'
                                      : '${100 - _displayHighestScore} %',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: GoogleFonts.suwannaphum().fontFamily,
                            color: Colors.red,
                          ),
                        ),
                        Text(
                          'Negative Mood',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: GoogleFonts.suwannaphum().fontFamily,
                            color: Colors.red,
                          ),
                        ),
                      ].toList(),
                    ),
                  ],
                ),
                Container(
                    width: double.infinity,
                    height: 85,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4,
                          color: Color(0x33000000),
                          offset: Offset(0, 0.0),
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        //--------------Diary----------------
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.content_paste,
                              color: Color(0xFF1300EB),
                              size: 28,
                            ),
                            Text(
                              'Diary',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                color: const Color(0xFF1300EB),
                              ),
                            ),
                          ].toList(),
                          //write a onclick navigate function to diary page
                        ),

                        //--------------Library----------------
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        const LibraryPage(),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //Add image icon
                              const Icon(
                                Icons.library_books_outlined,
                                color: Colors.black,
                                size: 28,
                              ),
                              Text(
                                'Library',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  color: Colors.black,
                                ),
                              ),
                            ].toList(),
                          ),
                        ),

                        //--------------Statistics----------------
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        const MoodSummary(),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.pie_chart_outline,
                                color: Colors.black,
                                size: 28,
                              ),
                              Text(
                                'Statistics',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  color: Colors.black,
                                ),
                              ),
                            ].toList(),
                          ),
                        ),

                        //--------------Articles----------------
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        const ArticlePage(),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.list,
                                color: Colors.black,
                                size: 28,
                              ),
                              Text(
                                'Articles',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  color: Colors.black,
                                ),
                              ),
                            ].toList(),
                          ),
                        ),
                      ],
                    ))
              ],
            ))
          ],
        ),
      ),
    );
  }
}
