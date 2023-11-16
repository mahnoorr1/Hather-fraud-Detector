import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/SigninPage.dart';

class LounchingPage extends StatefulWidget {
  const LounchingPage({super.key});

  @override
  _LounchingPageState createState() => _LounchingPageState(); //
}

class _LounchingPageState extends State<LounchingPage> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 5),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => SigninPage())));
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFF262262),
        body: SafeArea(
          //fading background
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [
                  0.0,
                  0.55,
                  0.6,
                  0.8,
                  1.0
                ], // More stops for smoother fading
                colors: [
                  Color.fromRGBO(
                      0, 167, 157, 0.99), // 70% opacity for Color(0xFF00A79D)
                  Color(0xFF262262),
                  Color(0xFF262262),
                  Color(0xFF262262),
                  Color(0xFF262262),
                ],
              ),
            ),
            // Rest of content
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 200.0, bottom: 10.0),
                  child: Image(
                      image: AssetImage(
                          'assets/images/Hather logo - NO BG-11_2.png')),
                ),
                Text(
                  'معًا بحَذر',
                  style: TextStyle(
                      fontSize: 44.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'IBMPlexSansArabic'),
                ),
                Text(
                  'نحو عالم رقمي آمن',
                  style: TextStyle(
                      fontSize: 44.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'IBMPlexSansArabic'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}