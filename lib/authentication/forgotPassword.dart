import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  @override
  void initState() {
    super.initState();
  }

  void dispode() {
    _emailController.dispose();
    super.dispose();
  }

  final String? url = dotenv.env["SERVER_URL"];
  void _resetPassword() async {
    try {
      final headers = {'Content-Type': 'application/json; charset=UTF-8'};
      var request = {
        "email": _emailController.text,
      };
      final response = await http.post(
        Uri.parse("$url/resetPassword"),
        headers: headers,
        body: json.encode(request),
      );
      var responsePayload = json.decode(response.body);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responsePayload['message']),
            duration: const Duration(seconds: 2),
          ),
        );
        //if successful, navigate to the diarypage.dart
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responsePayload['message']),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print("error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
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
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 70, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          "Forgot Password",
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
                child: Form(
                  key: _formKey,
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
                                      controller: _emailController,
                                      decoration: InputDecoration(
                                        fillColor: const Color(0x4DCACACA),
                                        filled: true,
                                        labelStyle: TextStyle(
                                          fontFamily: GoogleFonts.splineSans()
                                              .fontFamily,
                                          color: const Color(0xFFA0A5BA),
                                        ),
                                        alignLabelWithHint: true,
                                        hintText: 'example@gmail.com',
                                        hintStyle: TextStyle(
                                          fontSize: 12,
                                          fontFamily: GoogleFonts.splineSans()
                                              .fontFamily,
                                          color: const Color(0xFFA0A5BA),
                                        ),
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        contentPadding:
                                            const EdgeInsetsDirectional
                                                .fromSTEB(16, 5, 0, 0),
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

                      //-------------------------------Log In BUTTON---------------------------
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  15, 30, 15, 0),
                              child: FloatingActionButton(
                                onPressed: _resetPassword,
                                backgroundColor: const Color(0x981694B6),
                                elevation: 3,
                                child: const Text(
                                  'Reset Password',
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
