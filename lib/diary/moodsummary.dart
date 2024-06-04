// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mood_lift/model/liquidmodel.dart';
import "../model/monthselector.dart";

class MoodSummary extends StatefulWidget {
  const MoodSummary({super.key});

  @override
  State<MoodSummary> createState() => _MoodSummaryState();
}

class _MoodSummaryState extends State<MoodSummary> {
  final scafflodkey = GlobalKey<ScaffoldState>();
  DateTime _selectedMonth = DateTime.now(); // New variable

  void _handleMonthChanged(DateTime newMonth) {
    // New function
    setState(() {
      _selectedMonth = newMonth;
    });
    print(
        "Selected month: ${_selectedMonth.month}/${_selectedMonth.year}"); // Print the selected month and year
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scafflodkey,
      //-----------------------Background Img  Container----------------------
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
              padding: const EdgeInsetsDirectional.fromSTEB(0, 25, 0, 20),

              //-----------------------Title----------------------

              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Mood Summary',
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

            //-----------------------Statistics Container----------------------

            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(50, 15, 50, 0),
                      child: Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.5,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 4,
                              color: Color(0x33000000),
                              offset: Offset(0, 0.0),
                              spreadRadius: 6,
                            )
                          ],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0, 20, 0, 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //-----------------------Choose Month Year Row ----------------------
                              MonthSelector(
                                onMonthChanged:
                                    _handleMonthChanged, // Pass the new function
                              ),
                              //-----------------------Statistic Circle ----------------------
                              Flexible(
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 180,
                                      height: 180,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.black,
                                        ),
                                      ),
                                      child: const WaveCircle(percentage: 0.45),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      //---------------------- + / - Percentage----------------------

                                      Text(
                                        '80 %',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: GoogleFonts.suwannaphum()
                                              .fontFamily,
                                          color: Colors.green,
                                        ),
                                      ),
                                      Text(
                                        'Positive Mood',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: GoogleFonts.suwannaphum()
                                              .fontFamily,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        '20 %',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: GoogleFonts.suwannaphum()
                                              .fontFamily,
                                          color: Colors.red,
                                        ),
                                      ),
                                      Text(
                                        'Negative Mood',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: GoogleFonts.suwannaphum()
                                              .fontFamily,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ].toList(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Flexible(
              child: Stack(
                alignment: const AlignmentDirectional(0, 1),
                children: [
                  //-----------------------Cheering Words ----------------------

                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(40, 30, 40, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Wow, you\'ve truly shone this month!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: GoogleFonts.splineSans().fontFamily,
                            color: Colors.black,
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                          child: Text(
                            ' Keep up this fantastic energy, because it’s making a difference in more ways than you might realize.\nHere’s to many more months filled with joy and positivity—keep shining bright!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: GoogleFonts.splineSans().fontFamily,
                              color: Colors.black,
                              height: 1.9,
                            ),
                          ),
                        ),
                      ].toList(),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 87,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0),
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
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
                        Column(
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

                        //--------------Articles----------------
                        Column(
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
                      ],
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/dog.png',
                      width: 200,
                      height: 221,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}