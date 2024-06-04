import 'dart:convert';
import 'package:auth_state_manager/auth_state_manager.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mood_lift/diary/diaryhistorypage.dart';
import 'package:mood_lift/main.dart';
import "../diary/diarypage.dart";
import 'package:encrypt/encrypt.dart' as encrypt;

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  //final currentUser = FirebaseAuth.instance.currentUser;
  final emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  final passwordRegex = RegExp(
      r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{6,}$");
  String errorMessage = '';
  String errorEmail = '';
  String oldPassword = '';
  bool passwordVisible = false;

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  void dispode() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  final String? url = dotenv.env["SERVER_URL"];
  
  void _login() async {
    final key = encrypt.Key.fromUtf8(dotenv.env['ENCRYPTION_KEY']!);
    final iv = encrypt.IV.fromSecureRandom(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key,mode: AESMode.cbc));
    final encryptedPassword = encrypter.encrypt(_passwordController.text, iv:iv);
    // final decryptedPassword = encrypter.decrypt(encryptedPassword, iv:iv);
    try{
      final headers = {'Content-Type': 'application/json; charset=UTF-8' };
      var request = {
        "email": _emailController.text,
        "password": encryptedPassword.base64,
        "iv": iv.base64
      };
      final response = await http.post(
          Uri.parse("$url/login"),
          headers: headers,
          body: json.encode(request));
      var responsePayload =
          json.decode(response.body);
      if (response.statusCode == 200) {
        //to Store the token in the local storage
        await StorageUtil.storage.write(key: 'idToken', value: responsePayload['idToken']);
        await StorageUtil.storage.write(key: 'refreshToken', value: responsePayload['refreshToken']);
        await StorageUtil.storage.write(key: 'expiresIn', value: responsePayload['expiresIn']);
        String? token = await StorageUtil.storage.read(key: 'idToken');
        if (token != null) {
          //if successful, navigate to the diarypage.dart
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>const DiaryHistoryPage(),
            ),
          );
        }
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
      print("error: $e");
    }
  }

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
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 70, 0, 0),
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
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //-----------------------EMAIL---------------------------
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(24, 24, 0, 0),
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
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Email is required';
                                    } else if (!emailRegex.hasMatch(value)) {
                                      return 'Please enter a valid email address';
                                    } else if (errorEmail.isNotEmpty) {
                                      return errorEmail;
                                    }

                                    return null;
                                  },
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
                    padding: const EdgeInsetsDirectional.fromSTEB(24, 24, 0, 0),
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
                                  obscureText: passwordVisible,
                                  controller: _passwordController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Password is requried';
                                    } else if (errorMessage.isNotEmpty) {
                                      return errorMessage;
                                    }
                                    errorMessage = '';
                                    return null;
                                  },
                                  onChanged: (value) => setState(() {
                                    errorMessage = '';
                                  }),
                                  decoration: InputDecoration(
                                    suffixIcon: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 15.0),
                                      child: IconButton(
                                          icon: Icon(
                                            passwordVisible
                                                ? Icons.visibility_off_outlined
                                                : Icons.visibility_outlined,
                                            color: Colors.grey,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              passwordVisible =
                                                  !passwordVisible;
                                            });
                                          }),
                                    ),
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
                             onPressed: _login,
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
                              fontFamily: GoogleFonts.splineSans().fontFamily,
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
          ),
        ],
      ),
    );
  }
}
