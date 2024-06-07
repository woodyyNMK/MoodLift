
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mood_lift/diary/diaryviewpage.dart';
import "../model/customcalendar.dart";
import './diarypage.dart';
import './moodsummary.dart';
import './articlepage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mood_lift/main.dart';
import 'dart:convert';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final scafflodkey = GlobalKey<ScaffoldState>();
  final String? url = dotenv.env['SERVER_URL'];

  List<Map<String, dynamic>> diaries = [];

  void _showDiaries({required DateTime selectedDateTime}) async {
    String? token = await StorageUtil.storage.read(key: 'idToken');
    final DateTime param = selectedDateTime;

    try {
      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      };
      final response = await http
          .get(Uri.parse("$url/showDiaries?param=$param"), headers: headers);
      var responsePayload = json.decode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          diaries = (responsePayload['diaries'] as List)
            .map((item) => item as Map<String, dynamic>)
            .toList();
      });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responsePayload['message']),
            duration: const Duration(seconds: 2),
          ),
        );
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 25, 0, 20),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Choose a Date First',
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
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                //-----------------Table Calendar-----------------
                CustomCalendar(
                  onDaySelected: (selectedDateTime) {
                    _showDiaries(selectedDateTime: selectedDateTime);
                  },
                ),
                //--------------Diary List Session----------------
                Transform.translate(
                  offset: const Offset(0, -110),
                  child: Text(
                    'Past Diaries on this date',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.suwannaphum().fontFamily,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, -100),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: double.infinity,
                          //change responsive height according to the screen
                          height: MediaQuery.of(context).size.height * 0.2,
                          decoration: const BoxDecoration(),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                25, 15, 25, 0),
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.horizontal,
                              itemCount: diaries.length,
                              itemBuilder: (context, index) {
                                 return GestureDetector(
                                  onTap: () {
                                    String createdAtString = jsonEncode(diaries[index]['createdAt']);
                                    String formattedDateString = createdAtString.substring(10, 20);
                                    DateTime date = DateTime.parse(formattedDateString);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DiaryPageDetail(key: ValueKey(index), id: diaries[index]['_id'], text: diaries[index]['text'], date: date, positive: diaries[index]['positive'], negative: diaries[index]['negative'])
                                      ),
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.asset(
                                          'assets//images/book.png', // replace 'imageUrl' with the actual field name
                                          width: 80,
                                          height: 100,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      Text("Diary ${index + 1}", // replace 'title' with the actual field name
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: GoogleFonts.suwannaphum().fontFamily,
                                            color: Colors.black,
                                          )
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: double.infinity,
                  height: 87,
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
                      Column(
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
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
