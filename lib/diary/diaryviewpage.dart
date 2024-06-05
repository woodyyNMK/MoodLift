import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import './diarypage.dart';
import 'librarypage.dart';
import './moodsummary.dart';
import './articlepage.dart';
import 'package:intl/intl.dart';
class DiaryPageDetail extends StatefulWidget {

  final DateTime date;
  const DiaryPageDetail({required Key key,  required this.date}) : super(key: key);

  @override
  State<DiaryPageDetail> createState() => _DiaryPageDetailState();
}

class _DiaryPageDetailState extends State<DiaryPageDetail> {
  final scafflodkey = GlobalKey<ScaffoldState>();
  late String formattedDate;

  @override
  void initState() {
    super.initState();
    formattedDate = DateFormat('d MMMM yyyy').format(widget.date);
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
              'assets/background.png',
            ).image,
          ),
        ),
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
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              labelText: "Wrtite your thoughts here...",
                              alignLabelWithHint: true,
                            ),
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: GoogleFonts.splineSans().fontFamily,
                              color: Colors.black,
                            ),
                            maxLines: 33,
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
                                child: const FaIcon(
                                  FontAwesomeIcons.check,
                                  color: Color(0xFF000000),
                                  size: 25,
                                ),
                                onPressed: () {
                                  // print('IconButton pressed ...');
                                },
                              ),
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
