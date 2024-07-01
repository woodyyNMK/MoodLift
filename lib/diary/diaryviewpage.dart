import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mood_lift/main.dart';
import './diarypage.dart';
import 'librarypage.dart';
import './moodsummary.dart';
import '../article/articlelist.dart';
import 'package:intl/intl.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:encrypt/encrypt.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../model/nlpanalyze.dart';
import '../model/colormodel.dart';

class DiaryPageDetail extends StatefulWidget {
  final String text;
  final DateTime date;
  final int positive;
  final int negative;
  final int neutral;
  final String id;
  const DiaryPageDetail(
      {required key,
      required this.id,
      required this.text,
      required this.date,
      required this.positive,
      required this.negative,
      required this.neutral})
      : super(key: key);

  @override
  State<DiaryPageDetail> createState() => _DiaryPageDetailState();
}

class _DiaryPageDetailState extends State<DiaryPageDetail> {
  final scafflodkey = GlobalKey<ScaffoldState>();
  late String formattedDate;
  late var displayText;
  late var id;
  bool isEditing = false;
  final String? url = dotenv.env['SERVER_URL'];
  final key = encrypt.Key.fromUtf8(dotenv.env['ENCRYPTION_KEY']!);
  final iv = encrypt.IV.fromUtf8(dotenv.env['ENCRYPTION_IV']!);
  encrypt.Encrypter? encrypter;

  var _diaryTextController = TextEditingController();

  //---------------NLP sentiment Analysis function----------------
  late String _mood;
  late double _negative;
  late double _neutral;
  late double _positive;
  bool fromEditPage = false;
  LinearGradient _backgroundGradient =
      BackgroundColors.getSentimentColor('Neutral');

  void _updateSentimentState(
      String sentiment, double positive, double neutral, double negative) {
    setState(() {
      _mood = sentiment;
      _positive = positive;
      _neutral = neutral;
      _negative = negative;
      _backgroundGradient = BackgroundColors.getSentimentColor(sentiment);
    });
  }

  @override
  void initState() {
    super.initState();
    formattedDate = DateFormat('d MMMM yyyy').format(widget.date);
    encrypter = encrypt.Encrypter(encrypt.AES(key, mode: AESMode.cbc));
    final encryptedText = Encrypted.fromBase64(widget.text);
    displayText = encrypter?.decrypt(encryptedText, iv: iv);
    id = widget.id;
    _diaryTextController = TextEditingController(text: displayText);
    _positive = widget.positive.toDouble();
    _negative = widget.negative.toDouble();
    _neutral = widget.neutral.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scafflodkey,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: Image.asset(
              'assets/images/background.png',
            ).image,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 25, 0, 0),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.chevron_left_outlined,
                        color: Colors.black,
                        size: 34,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LibraryPage(),
                            ));
                      },
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 0, 25, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Diary on ',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: GoogleFonts.suwannaphum().fontFamily,
                              color: const Color.fromRGBO(22, 148, 182, 1),
                              shadows: const [
                                Shadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.25),
                                  offset: Offset(0, 8),
                                  blurRadius: 8,
                                )
                              ],
                            ),
                          ),
                          Text(
                            formattedDate,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: GoogleFonts.suwannaphum().fontFamily,
                              color: const Color.fromRGBO(22, 148, 182, 1),
                              shadows: const [
                                Shadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.25),
                                  offset: Offset(0, 8),
                                  blurRadius: 8,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
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
                    height: MediaQuery.sizeOf(context).height * 0.72,
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
                            controller: _diaryTextController,
                            // initialValue: displayText,
                            readOnly: !isEditing,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Here's Past Memory",
                              alignLabelWithHint: true,
                            ),
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: GoogleFonts.splineSans().fontFamily,
                              color: Colors.black,
                            ),
                            maxLines: 25,
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
                                child: FaIcon(
                                  isEditing
                                      ? FontAwesomeIcons.check
                                      : FontAwesomeIcons.edit,
                                  color: const Color(0xFF000000),
                                  size: 25,
                                ),
                                onPressed: () async {
                                  if (isEditing == true) {
                                    //calling _analyzeSentiment from diarypage.dart
                                    SentimentAnalyzer sentimentAnalyzer =
                                        SentimentAnalyzer();

                                    await sentimentAnalyzer.analyzeSentiment(
                                      _diaryTextController.toString(),
                                      _updateSentimentState,
                                      fromEditPage = true,
                                    );
                                    String? token = await StorageUtil.storage
                                        .read(key: 'idToken');
                                    final String param = id;
                                    final encryptedDiary = encrypter?.encrypt(
                                        _diaryTextController.text,
                                        iv: iv);
                                    final headers = {
                                      'Content-Type':
                                          'application/json; charset=UTF-8',
                                      'Authorization': 'Bearer $token'
                                    };
                                    var request = {
                                      "diary": encryptedDiary!.base64,
                                      "positive": _positive,
                                      "negative": _negative,
                                      "neutral": _neutral,
                                    };
                                    final response = await http.put(
                                        Uri.parse(
                                            "$url/updateDiary?param=$param"),
                                        headers: headers,
                                        body: json.encode(request));
                                    var responsePayload =
                                        json.decode(response.body);
                                    if (response.statusCode == 200) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              Text(responsePayload['message']),
                                          duration: const Duration(seconds: 2),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              Text(responsePayload['message']),
                                          duration: const Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  }
                                  setState(() {
                                    isEditing = !isEditing;
                                  });
                                },
                              ),
                            ),

                            //---------------Mood SUmmary Text Field----------------
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                isEditing
                                    ? Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 40),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              TextButton(
                                                onPressed: () async {
                                                  String? token =
                                                      await StorageUtil.storage
                                                          .read(key: 'idToken');
                                                  final String param = id;
                                                  final headers = {
                                                    'Content-Type':
                                                        'application/json; charset=UTF-8',
                                                    'Authorization':
                                                        'Bearer $token',
                                                  };
                                                  final response =
                                                      await http.delete(
                                                    Uri.parse(
                                                        "$url/deleteDiary?param=$param"),
                                                    headers: headers,
                                                  );
                                                  var responsePayload = json
                                                      .decode(response.body);
                                                  if (response.statusCode ==
                                                      200) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                            responsePayload[
                                                                'message']),
                                                        duration:
                                                            const Duration(
                                                                seconds: 2),
                                                      ),
                                                    );
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const LibraryPage(),
                                                      ),
                                                    );
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                            responsePayload[
                                                                'message']),
                                                        duration:
                                                            const Duration(
                                                                seconds: 2),
                                                      ),
                                                    );
                                                  }
                                                },
                                                style: TextButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      //border color
                                                      side: const BorderSide(
                                                          color: Colors.red,
                                                          width: 1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0),
                                                    ),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 16,
                                                        vertical: 8)),
                                                child: const Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(15, 0, 0, 25),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Mood Percentage ',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontFamily:
                                                    GoogleFonts.splineSans()
                                                        .fontFamily,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              'Positive    : $_positive%',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontFamily:
                                                    GoogleFonts.splineSans()
                                                        .fontFamily,
                                                color: Colors.green,
                                              ),
                                            ),
                                            Text(
                                              'Negative  : $_negative%',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontFamily:
                                                    GoogleFonts.splineSans()
                                                        .fontFamily,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
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
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        const DiaryPage(),
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
                                Icons.content_paste,
                                color: Colors.black,
                                size: 28,
                              ),
                              Text(
                                'Diary',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  color: Colors.black,
                                ),
                              ),
                            ].toList(),
                            //write a onclick navigate function to diary page
                          ),
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
                                color: Color(0xFF1300EB),
                                size: 28,
                              ),
                              Text(
                                'Library',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  color: const Color(0xFF1300EB),
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
                                        const Article(),
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
