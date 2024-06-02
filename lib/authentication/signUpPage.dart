import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //I want responsive height of the container
      // height: MediaQuery.of(context).size.height * 1,
      decoration: const BoxDecoration(
        color: Color(0x981694B6),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 100, 0, 0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w400,
                            fontFamily: GoogleFonts.suwannaphum().fontFamily,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          "Please sign up to get started",
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: GoogleFonts.suwannaphum().fontFamily,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //-----------------------NAME---------------------------
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(24, 24, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            "NAME",
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: GoogleFonts.splineSans().fontFamily,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Opacity(
                            opacity: 0.5,
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  15, 8, 15, 0),
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: const Color(0x4DCACACA),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Container(
                                  width: 327,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      labelStyle: TextStyle(
                                        fontFamily:
                                            GoogleFonts.splineSans().fontFamily,
                                        color: const Color(0xFFA0A5BA),
                                      ),
                                      alignLabelWithHint: true,
                                      hintText: 'john doe',
                                      hintStyle: TextStyle(
                                        fontSize: 12,
                                        fontFamily:
                                            GoogleFonts.splineSans().fontFamily,
                                        color: const Color(0xFFA0A5BA),
                                      ),
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              16, 5, 0, 0),
                                    ),
                                    style: TextStyle(
                                      fontFamily:
                                          GoogleFonts.splineSans().fontFamily,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    //-----------------------EMAIL---------------------------
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(24, 24, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            "EMAIL",
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: GoogleFonts.splineSans().fontFamily,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Opacity(
                            opacity: 0.5,
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  15, 8, 15, 0),
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: const Color(0x4DCACACA),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Container(
                                  width: 327,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      labelStyle: TextStyle(
                                        fontFamily:
                                            GoogleFonts.splineSans().fontFamily,
                                        color: const Color(0xFFA0A5BA),
                                      ),
                                      alignLabelWithHint: true,
                                      hintText: 'example@gmail.com',
                                      hintStyle: TextStyle(
                                        fontSize: 12,
                                        fontFamily:
                                            GoogleFonts.splineSans().fontFamily,
                                        color: const Color(0xFFA0A5BA),
                                      ),
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              16, 5, 0, 0),
                                    ),
                                    style: TextStyle(
                                      fontFamily:
                                          GoogleFonts.splineSans().fontFamily,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    //-------------------------------PASSWORD---------------------------
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(24, 24, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            "PASSWORD",
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: GoogleFonts.splineSans().fontFamily,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Opacity(
                            opacity: 0.5,
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  15, 8, 15, 0),
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: const Color(0x4DCACACA),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Container(
                                  width: 327,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      labelStyle: TextStyle(
                                        fontFamily:
                                            GoogleFonts.splineSans().fontFamily,
                                        color: const Color(0xFFA0A5BA),
                                      ),
                                      alignLabelWithHint: true,
                                      hintText: '* * * * * * * *',
                                      hintStyle: TextStyle(
                                        fontSize: 12,
                                        fontFamily:
                                            GoogleFonts.splineSans().fontFamily,
                                        color: const Color(0xFFA0A5BA),
                                      ),
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              16, 14, 0, 0),
                                    ),
                                    style: TextStyle(
                                      fontFamily:
                                          GoogleFonts.splineSans().fontFamily,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    //-------------------------------CONFIRM PASSWORD---------------------------
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(24, 24, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            "RE-TYPE PASSWORD",
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: GoogleFonts.splineSans().fontFamily,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Opacity(
                            opacity: 0.5,
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  15, 8, 15, 0),
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: const Color(0x4DCACACA),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Container(
                                  width: 327,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      labelStyle: TextStyle(
                                        fontFamily:
                                            GoogleFonts.splineSans().fontFamily,
                                        color: const Color(0xFFA0A5BA),
                                      ),
                                      alignLabelWithHint: true,
                                      hintText: '* * * * * * * *',
                                      hintStyle: TextStyle(
                                        fontSize: 12,
                                        fontFamily:
                                            GoogleFonts.splineSans().fontFamily,
                                        color: const Color(0xFFA0A5BA),
                                      ),
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              16, 14, 0, 0),
                                    ),
                                    style: TextStyle(
                                      fontFamily:
                                          GoogleFonts.splineSans().fontFamily,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    //-------------------------------SIGN UP BUTTON---------------------------
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                15, 29, 15, 29),
                            child: FloatingActionButton(
                              onPressed: () {},
                              backgroundColor: const Color(0x981694B6),
                              elevation: 3,
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
