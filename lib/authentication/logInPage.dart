import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //I want responsive height of the container
      // height: MediaQuery.of(context).size.height * 1,
      decoration: const BoxDecoration(
        color: Color(0x981694B6),
      ),
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
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 100, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          "Log In",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w400,
                            fontFamily: GoogleFonts.suwannaphum().fontFamily,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "Sign into your existing account",
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
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.6,
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
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              width: 327,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  fillColor: const Color(0x4DCACACA),
                                  filled: true,
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
                                  errorBorder: InputBorder.none,
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
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              width: 327,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  fillColor: const Color(0x4DCACACA),
                                  filled: true,
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
                                  errorBorder: InputBorder.none,
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
                //-------------------------------Remember Me ---------------------------
                Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(15, 24, 15, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: false,
                            onChanged: (value) {},
                            activeColor: const Color(0xFF1694B6),
                          ),
                          Text(
                            "Remember Me",
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: GoogleFonts.splineSans().fontFamily,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      
                      TextButton(
                        onPressed: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => SignUpPage(),
                          //   ),
                          // );
                        },
                        child: Text(
                          "Forget Password ?",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: GoogleFonts.splineSans().fontFamily,
                            color: const Color(0xFF1694B6),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //-------------------------------Log In BUTTON---------------------------
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            15, 15, 15, 0),
                        child: FloatingActionButton(
                          onPressed: () {},
                          backgroundColor: const Color(0x981694B6),
                          elevation: 3,
                          child: const Text(
                            'LogIn',
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
                ),
                //-------------------------------Don't Have Account ---------------------------
                //Don't have an account ? Sign Up in one row
                Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(15, 24, 15, 24),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: GoogleFonts.splineSans().fontFamily,
                          color: Colors.black,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => SignUpPage(),
                          //   ),
                          // );
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily:
                                GoogleFonts.splineSans().fontFamily,
                            color: const Color(0xFF1694B6),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
