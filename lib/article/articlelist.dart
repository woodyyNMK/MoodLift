import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import './articledetail.dart';

class Article extends StatefulWidget {
  const Article({super.key});

  @override
  State<Article> createState() => _ArticleState();
}

class _ArticleState extends State<Article> {
  List<Map<String, dynamic>> diaries = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 25, 0, 20),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Articles',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.poppins().fontFamily,
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

            //--------------ArticleList----------------
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: ListView.builder(
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.vertical,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        const ArticleDetail(),
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
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: const [
                                    BoxShadow(
                                      blurRadius: 4,
                                      color: Color(0x33000000),
                                      offset: Offset(0, 0.0),
                                      spreadRadius: 4,
                                    )
                                  ],
                                ),
                                child: Row(children: [
                                  // Pic
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(22),
                                      child: Image.asset(
                                          'assets/images/dog.png',
                                          width: 125,
                                          height: 125,
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  Flexible(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  'Health and How to Heal to feel better? A deep discussion',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily:
                                                        GoogleFonts.poppins()
                                                            .fontFamily,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                            '27 April 2024',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                              fontFamily: GoogleFonts.poppins()
                                                  .fontFamily,
                                              color: const Color(0xFFB89494),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ),
            // ),
            //
            //--------------BottomNavBar----------------
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
                          // Navigator.push(
                          //   context,
                          //   PageRouteBuilder(
                          //     pageBuilder:
                          //         (context, animation, secondaryAnimation) =>
                          //             const DiaryPage(),
                          //     transitionsBuilder: (context, animation,
                          //         secondaryAnimation, child) {
                          //       return FadeTransition(
                          //         opacity: animation,
                          //         child: child,
                          //       );
                          //     },
                          //   ),
                          // );
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

                      //--------------Statistics----------------
                      GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   PageRouteBuilder(
                          //     pageBuilder:
                          //         (context, animation, secondaryAnimation) =>
                          //             const MoodSummary(),
                          //     transitionsBuilder: (context, animation,
                          //         secondaryAnimation, child) {
                          //       return FadeTransition(
                          //         opacity: animation,
                          //         child: child,
                          //       );
                          //     },
                          //   ),
                          // );
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
                          // Navigator.push(
                          //   context,
                          //   PageRouteBuilder(
                          //     pageBuilder:
                          //         (context, animation, secondaryAnimation) =>
                          //             const ArticlePage(),
                          //     transitionsBuilder: (context, animation,
                          //         secondaryAnimation, child) {
                          //       return FadeTransition(
                          //         opacity: animation,
                          //         child: child,
                          //       );
                          //     },
                          //   ),
                          // );
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.list,
                              color: Color(0xFF1694B6),
                              size: 28,
                            ),
                            Text(
                              'Articles',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                color: const Color(0xFF1694B6),
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
