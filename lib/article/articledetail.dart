import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

class ArticleDetail extends StatefulWidget {
  const ArticleDetail({super.key});

  @override
  State<ArticleDetail> createState() => _ArticleDetailState();
}

class _ArticleDetailState extends State<ArticleDetail> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var orientation = MediaQuery.of(context).orientation;

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
              child: Stack(
                // mainAxisSize: MainAxisSize.max,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Positioned(
                    left: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      ' Articles Detail',
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
                  ),
                ],
              ),
            ),

            //--------------ArticleDetail----------------

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: Container(
                          width: width,
                          height: height / 3,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              width: width,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: Image.asset(
                                    'assets/images/background.png',
                                  ).image,
                                ),
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Expanded(
                        child: Text(
                            '$width Health and How to Heal to feel better? A deep discussion',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              color: Colors.black,
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Expanded(
                        child: Text(
                            "Scriptures on mental health are there to give us comfort and remind us that God is with us, even in those struggles. When our mind starts racing, our stress levels rise or we become anxious, let us remember that God told us we do not have to be afraid.Scriptures on mental health are there to give us comfort and remind us that God is with us, even in those struggles. When our mind starts racing, our stress levels rise or we become anxious",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              color: Colors.black,
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Expanded(
                        child: Text(
                            "Scriptures on mental health are there to give us comfort and remind us that God is with us, even in those struggles. When our mind starts racing, our stress levels rise or we become anxious, let us remember that God told us we do not have to be afraid.Scriptures on mental health are there to give us comfort and remind us that God is with us, even in those struggles. When our mind starts racing, our stress levels rise or we become anxious",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              color: Colors.black,
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Expanded(
                        child: Text(
                            "Scriptures on mental health are there to give us comfort and remind us that God is with us, even in those struggles. When our mind starts racing, our stress levels rise or we become anxious, let us remember that God told us we do not have to be afraid.Scriptures on mental health are there to give us comfort and remind us that God is with us, even in those struggles. When our mind starts racing, our stress levels rise or we become anxious",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              color: Colors.black,
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Expanded(
                        child: Text(
                            "Scriptures on mental health are there to give us comfort and remind us that God is with us, even in those struggles. When our mind starts racing, our stress levels rise or we become anxious, let us remember that God told us we do not have to be afraid.Scriptures on mental health are there to give us comfort and remind us that God is with us, even in those struggles. When our mind starts racing, our stress levels rise or we become anxious",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              color: Colors.black,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
