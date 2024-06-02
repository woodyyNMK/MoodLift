import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String errorMessage = '';
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool passwordVisibleOne = false; //for eye icon
  bool passwordVisibleTwo = false; //for eye icon
  final nameRegx = RegExp(r'^[a-zA-Z0-9\s]+$');

  final emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  final passwordRegex = RegExp(
      r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{6,}$");

  // bool userCheckforIcon = false;
  @override
  void initState() {
    super.initState();
    passwordVisibleOne = true;
    passwordVisibleTwo = true;
  }

  void dispode() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 100, 0, 0),
                    child: Row(
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
            child: Form(
              key: _formKey,
              child: Container(
                width: double.infinity,
                // height: MediaQuery.of(context).size.height * 0.6,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
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
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: TextFormField(
                                    controller: _nameController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Enter a Name';
                                      } else if (!nameRegx.hasMatch(value)) {
                                        // userCheckforIcon = true;
                                        return 'Name must contain only letters and numbers';
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
                                      hintText: 'john doe',
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
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Container(
                                    width: 327,
                                    child: TextFormField(
                                      controller: _emailController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please Enter an email address';
                                        } else if (!emailRegex
                                            .hasMatch(value)) {
                                          return 'Email address is not valid';
                                        } else if (errorMessage.isNotEmpty) {
                                          return errorMessage;
                                        }
                                        return null;
                                      },
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
                                      obscureText: passwordVisibleOne,
                                      controller: _passwordController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please Enter a password';
                                        } else if (!passwordRegex
                                            .hasMatch(value)) {
                                          return 'Password must contain at least 6 characters, including:\n'
                                              '• Uppercase, LowerCase Numbers and special characters';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        fillColor: const Color(0x4DCACACA),
                                        filled: true,
                                        labelStyle: TextStyle(
                                          fontFamily: GoogleFonts.splineSans()
                                              .fontFamily,
                                          color: const Color(0xFFA0A5BA),
                                        ),
                                        alignLabelWithHint: true,
                                        hintText: '* * * * * * * *',
                                        hintStyle: TextStyle(
                                          fontSize: 12,
                                          fontFamily: GoogleFonts.splineSans()
                                              .fontFamily,
                                          color: const Color(0xFFA0A5BA),
                                        ),
                                        suffixIcon: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 15.0),
                                          child: IconButton(
                                              icon: Icon(
                                                passwordVisibleOne
                                                    ? Icons
                                                        .visibility_off_outlined
                                                    : Icons.visibility_outlined,
                                                color: Colors.grey,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  passwordVisibleOne =
                                                      !passwordVisibleOne;
                                                });
                                              }),
                                        ),
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        contentPadding:
                                            const EdgeInsetsDirectional
                                                .fromSTEB(16, 14, 0, 0),
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
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Container(
                                    width: 327,
                                    child: TextFormField(
                                      obscureText: passwordVisibleTwo,
                                      controller: _confirmPasswordController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please Enter Your Passowrd Again';
                                        } else if (value !=
                                            _passwordController.text) {
                                          return 'Password does Not Match';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        fillColor: const Color(0x4DCACACA),
                                        filled: true,
                                        labelStyle: TextStyle(
                                          fontFamily: GoogleFonts.splineSans()
                                              .fontFamily,
                                          color: const Color(0xFFA0A5BA),
                                        ),
                                        alignLabelWithHint: true,
                                        hintText: '* * * * * * * *',
                                        hintStyle: TextStyle(
                                          fontSize: 12,
                                          fontFamily: GoogleFonts.splineSans()
                                              .fontFamily,
                                          color: const Color(0xFFA0A5BA),
                                        ),
                                        suffixIcon: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 15.0),
                                          child: IconButton(
                                              icon: Icon(
                                                passwordVisibleTwo
                                                    ? Icons
                                                        .visibility_off_outlined
                                                    : Icons.visibility_outlined,
                                                color: Colors.grey,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  passwordVisibleTwo =
                                                      !passwordVisibleTwo;
                                                });
                                              }),
                                        ),
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        contentPadding:
                                            const EdgeInsetsDirectional
                                                .fromSTEB(16, 14, 0, 0),
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
                                onPressed: () {
                                  //check if its valid or not and post it to the flask server
                                  if (_formKey.currentState!.validate()) {
                                    print('Name: ${_nameController.text}');
                                    print('Email: ${_emailController.text}');
                                    print('Password: ${_passwordController.text}');
                                    print('Confirm Password: ${_confirmPasswordController.text}');
                                    //using Flask server to post the data to the server
                                    // postSignUpData();
                                    
                                  }
                                },
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
            ),
          ),
        ],
      ),
    );
  }
}
